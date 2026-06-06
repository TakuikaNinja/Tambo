.include "defs.asm"
.include "ram.asm"
.include "constants.asm"
;.include "macros.asm"

.include "TamboFiles/tambo_includes.asm"

; enable backslash escape sequences
.feature string_escapes +

.segment "HEADER"
  .byte "NES", $1a ; iNES header identifier
  .byte $01 ; 1x 16KB PRG
  .byte $01 ; 1x  8KB CHR
  .byte $00 ; Mapper 0; No battery; Vertical arrangement ("Horizontal mirroring")
  .byte $08 ; Mapper 0; NES 2.0 identifier
  .byte $00 ; No submapper
  .byte $00 ; PRG-ROM not 4 MiB or larger
  .byte $00 ; No PRG-RAM
  .byte $00 ; No CHR-RAM
  .byte $02 ; Multiple regions (i.e. NTSC/PAL/Dendy)
  .byte $00 ; Not a Vs. System or extended console type
  .byte $00 ; No misc. ROMs
  .byte $00 ; Standard controllers

.segment "CODE"

Reset:
		sei
		cld
		ldx #$ff
		stx JOY2
		txs
		inx
		stx PPU_CTRL
		stx PPU_MASK
		stx DMC_FREQ
		bit PPU_STATUS

; video system detection code from lidnariq: https://forums.nesdev.org/viewtopic.php?p=163258#p163258
	;;; use the power-on wait to detect video system-
;		ldx #0
		ldy #0
	@vwait1:
		bit PPU_STATUS
		bpl @vwait1  ; at this point, about 27384 cycles have passed
	@vwait2:
		inx
		bne @noincy
		iny
	@noincy:
		bit PPU_STATUS
		bpl @vwait2  ; at this point, about 57165 cycles have passed

	;;; BUT because of a hardware oversight, we might have missed a vblank flag.
	;;;  so we need to both check for 1Vbl and 2Vbl
	;;; NTSC NES: 29780 cycles / 12.005 -> $9B0 or $1361 (Y:X)
	;;; PAL NES:  33247 cycles / 12.005 -> $AD1 or $15A2
	;;; Dendy:    35464 cycles / 12.005 -> $B8A or $1714

		tya
		cmp #16
		bcc @nodiv2
		lsr
	@nodiv2:
		clc
		adc #<-9
		cmp #3
		bcc @noclip3
		lda #3
	@noclip3:
	;;; Right now, A contains 0,1,2,3 for NTSC,PAL,Dendy,Bad
		tay ; save for later
		
		lda #$00
		tax
@clrmem:
		sta $00,x
		sta $0100,x
		sta $0200,x
		sta $0300,x
		sta $0400,x
		sta $0500,x
		sta $0600,x
		sta $0700,x
		inx
		bne @clrmem
		
		sty soundRegion
		jsr tambo_initAPU
		
		jsr InitNametables
		
		lda #$80
		sta vram_buffer ; mark buffer as empty (just in case)
		sta PPU_CTRL_MIRROR
		sta PPU_CTRL
Main:
		jsr CheckButtonPresses
		jsr HandleGameMode
		jsr WaitForNMI
		beq Main ; [unconditional branch]

WaitForNMI:
		inc NMIReady
@loop:
		lda NMIReady
		bne @loop
		rts

CheckButtonPresses:
		ldx #$01
:
		ldy P1_PRESSED,x
		lda P1_HELD,x
		eor #$ff
		and P1_PRESSED,x
		sta P1_PRESSED,x
		sty P1_HELD,x
		dex
		bpl :-
		rts

NMI:
		pha
		txa
		pha
		tya
		pha
		
		bit NMISoftDisable
		bmi @soundOnly
		
		lda NMIReady
		beq @setScroll
		dec NMIReady
		jsr HandleControllersAndPPU

		lda NeedPPUMask
		beq @setScroll
		
		lda PPU_MASK_MIRROR
		sta PPU_MASK
		dec NeedPPUMask
		
@setScroll:
		lda #$00
		sta PPU_SCROLL
		sta PPU_SCROLL
		lda PPU_CTRL_MIRROR
		sta PPU_CTRL

; raster time display using grayscale mode
; but delay until around visible scanline 32 first
@soundOnly:
		ldx PPU_MASK_MIRROR
		inx
		ldy soundRegion
		lda RasterDelays,y
		tay
@delay:
		brk #$00 ; 13 cycles for each BRK+RTI
		brk #$00
		brk #$00
		brk #$00
		brk #$00
		dey
		bne @delay
		stx PPU_MASK

		; run sound driver
		jsr tambo_soundUpdate

; restore state
		lda PPU_MASK_MIRROR
		sta PPU_MASK
		
		pla
		tay
		pla
		tax
		pla
IRQ:
		rti

; approximate delays to start at visible scanline 32
RasterDelays:
	.byte $49, $90, $49

HandleControllersAndPPU:
		lda soundRegion
		cmp #REGION::PAL
		bne NTSC_Handler

; PAL needs OAM DMA first, don't need to worry about DMC controller conflicts
PAL_Handler:
		lda #$00
		sta PPU_OAM_ADDR
		lda #>oam
		sta OAM_DMA
		jsr TransferVRAM
		jmp ReadControllers
		
; NTSC (and probably Dendy too) benefit from doing OAM DMA later
; (otherwise the sync'd controller reading would eat into vblank)
NTSC_Handler:
		jsr TransferVRAM
		
; OAM DMA sync for glitch-free controller reads
OAMDMA_Controller_Sync:
		lda #$00
		sta $2003
		lda #>oam
		sta $4014          ; ------ OAM DMA ------
ReadControllers:
		ldx #1             ; get put          <- strobe code must take an odd number of cycles total
		stx Buttons+0      ; get put get      <- buttons must be in the zeropage
		stx $4016          ; put get put get
		dex                ; put get
		stx $4016          ; put get put get
@loop:
		lda $4017          ; put get put GET  <- loop code must take an even number of cycles total
		and #3             ; put get
		cmp #1             ; put get
		rol Buttons+1,x    ; put get put get put get (X = 0; waste 1 cycle for alignment)
		lda $4016          ; put get put GET
		and #3             ; put get
		cmp #1             ; put get
		rol Buttons+0      ; put get put get put
		bcc @loop          ; get put [get]    <- this branch must not be allowed to cross a page
		rts

TransferVRAM:
		lda NeedDraw
		beq @skip
		
		ldx #$ff
		bne @readDest
		
@writeStripe:
		pha
		bit PPU_STATUS
		sta PPU_ADDR
		inx
		lda vram_buffer,x ; dest lo byte
		sta PPU_ADDR
		inx
		lda PPU_CTRL_MIRROR
		and #%10111011 ; +1 increment by default
		ldy vram_buffer,x ; length/flags
		bpl @horizontal
		ora #%00000100 ; bit 7 set = +32 increment
@horizontal:
		sta PPU_CTRL
		tya
		and #$7f
		cmp #$40 ; carry will contain bit 6 (fill flag)
		and #$3f ; now mask length bits to use as counter
		tay
		inx
		bcc @writeByte
		
@checkRun:
		bcs @writeByte
		inx
@writeByte:
		lda vram_buffer,x
		sta PPU_DATA
		dey
		bne @checkRun
		
		; if we just wrote to palette RAM, safely move v out of it
		pla
		cmp #$3f
		bne @readDest
		
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR
		sta PPU_ADDR
		sta PPU_ADDR

@readDest:
		inx
		lda vram_buffer,x ; dest hi byte
		bpl @writeStripe ; bit 7 set = end of data
		sta vram_buffer ; mark buffer as empty (just in case)
		dec NeedDraw
@skip:
		rts

InitNametables:
		lda #$20 ; top-left
		jsr @oneNametable
		lda #$2c ; bottom-right (works with either arrangement)
		
@oneNametable:
		bit PPU_STATUS
		sta PPU_ADDR
		lda #$00
		sta PPU_ADDR
		tay
@fillLoop:
		sta PPU_DATA
		sta PPU_DATA
		sta PPU_DATA
		sta PPU_DATA
		iny
		bne @fillLoop
		rts

InitPalettes:
		lda #$3f
		sta vram_buffer
		lda #$00
		sta vram_buffer+1
		lda #(%01000000 | 32) ; fill 32 bytes
		sta vram_buffer+2
		lda #$0f
		sta vram_buffer+3
		lda #$ff
		sta vram_buffer+4
		inc NeedDraw
		rts

HandleGameMode:
		lda Mode
		bne :+
		jsr InitPalettes
		lda #%00001010 ; enable BG rendering
		sta PPU_MASK_MIRROR
		inc NeedPPUMask
		inc Mode
		lda #$00
		sta currentTrack
		jmp tambo_playTrack
:
		lda P1_PRESSED
		and #(BUTTON_LEFT | BUTTON_RIGHT)
		beq :+
		lda currentTrack
		eor #1
		sta currentTrack
		jmp tambo_playTrack
:
		rts

	.include "TamboFiles/tambo.asm"
	.out .sprintf ("Tambo driver: %d bytes", *-periodTableLo)
	
	.include "Songs/tambo_static.asm"
	.include "Songs/tambo_test_song.asm"
	.include "Songs/apu_dance.asm"
	.out .sprintf ("Sound data: %d bytes", *-tambo_maxTracks)

.segment "VECTORS"
	.addr NMI
	.addr Reset
	.addr IRQ

.segment "CHRDATA"
	.incbin "Jroatch-chr-sheet.chr"
	.incbin "Jroatch-chr-sheet.chr"

