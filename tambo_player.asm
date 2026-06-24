; enable backslash escape sequences
.feature string_escapes +

.include "defs.asm"
.include "ram.asm"
.include "constants.asm"
;.include "macros.asm"

.include "TamboFiles/tambo_includes.asm"

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
  .byte $01 ; Standard controllers

.segment "CODE"

tambo_samples_start:
.include "Songs/tambo_samples.asm"
.out .sprintf ("\nDPCM samples: %d bytes\n", *-tambo_samples_start)

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
		dec $0200,x ; offscreen values
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
		
		lda #%10010000 ; set BG pattern table selection
		sta vram_buffer ; mark buffer as empty (just in case)
		sta PPU_CTRL_MIRROR
		bit PPU_STATUS
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
		bmi @skipNMI
		
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
; but delay until we get a sprite 0 hit
		bit SkipSound
		bmi @skipNMI
		ldx PPU_MASK_MIRROR
		inx
		ldy soundRegion
		lda RasterDelays,y
		tay
@sprite0Wait1:
		bit PPU_STATUS
		bvs @sprite0Wait1
@sprite0Wait2:
		bit PPU_STATUS
		bvc @sprite0Wait2
@delay:
		brk #$00 ; 13 cycles for each BRK+RTI
		dey
		bne @delay
		stx PPU_MASK
		; run sound driver
		jsr tambo_soundUpdate

; restore state
		lda PPU_MASK_MIRROR
		sta PPU_MASK
@skipNMI:
		pla
		tay
		pla
		tax
		pla
IRQ:
		rti

RasterDelays:
	.byte $15, $13, $15

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

HandleGameMode:
		lda Mode
		bne @handleInputs
		
		ldy #$80
		sty SkipSound ; don't want sound driver + raster display yet
		jsr InitSprites
		
		; init screen
		ldx #$00
@loop:
		lda ScreenData,x
		sta vram_buffer,x
		inx
		cpx #ScreenDataSize
		bcc @loop
		
		jsr WaitForNMI
		sty NMISoftDisable
		inc NeedDraw
		jsr TransferVRAM ; bulk transfer
		
		lda #%00011110 ; enable rendering
		sta PPU_MASK_MIRROR
		inc NeedPPUMask
		asl NMISoftDisable
		jsr WaitForNMI ; update PPU_MASK & let sprite evaluation occur
		
		inc Mode
		lda #$00
		sta SkipSound
		sta selectedTrack
		sta currentTrack
		jmp tambo_playTrack

@handleInputs:
		lda P1_PRESSED
		and #(BUTTON_LEFT | BUTTON_RIGHT)
		beq :+
		jsr SelectTrack
:
		lda P1_PRESSED
		and #BUTTON_SELECT
		beq :+
		jsr tambo_stopTrack
:
		lda P1_PRESSED
		and #BUTTON_START
		beq :+
		jsr tambo_pauseTrack
:
		lda P1_PRESSED
		and #BUTTON_A
		beq :+
		lda #$00
		sta currentSFX
		jsr tambo_playSFX
:
		lda P1_PRESSED
		and #BUTTON_B
		beq :+
		lda #$01
		sta currentSFX
		jsr tambo_playSFX
:
		rts

SelectTrack:	
		cmp #BUTTON_LEFT
		bne @checkRight
		ldy selectedTrack
		bne @decrement
		ldy tambo_maxTracks
@decrement:
		dey
@checkRight:
		cmp #BUTTON_RIGHT
		bne @playTrack
		ldy selectedTrack
		iny
		cpy tambo_maxTracks
		bcc @playTrack
		ldy #$00
@playTrack:
		sty selectedTrack
		sty currentTrack
		jmp tambo_playTrack

InitSprites:
		lda #83
		sta oam ; Y
		lda #$81
		sta oam+1 ; tile
		lda #0
		sta oam+2 ; attributes
		lda #176
		sta oam+3 ; X
		rts
		

ScreenData:
	.dbyt $3f00
	.byte 32
	.repeat 8
	.byte $0f, $00, $10, $20
	.endrepeat
	.incbin "Screens/screen.nam.out"
	ScreenDataSize = *-ScreenData


	.include "TamboFiles/tambo.asm"
	.out .sprintf ("Tambo driver: %d bytes", *-periodTableLo)
	
	.include "Songs/tambo_static.asm"
	.out .sprintf ("\nStatic data: %d bytes", *-tambo_maxTracks)
	.include "Songs/tambo_test_song.asm"
	.out .sprintf ("Music data (Test song): %d bytes", *-testsong_header)
	.include "Songs/apu_dance.asm"
	.out .sprintf ("Music data (APU Dance): %d bytes", *-apu_dance_header)
	.include "Songs/hiscore_party.asm"
	.out .sprintf ("Music data (Hi-Score Party): %d bytes", *-hiscore_party_header)
	.include "Songs/tambo_sfx.asm"
	.out .sprintf ("SFX data: %d bytes", *-sfx_start)
	.out .sprintf ("Total sound data: %d bytes\n", *-tambo_maxTracks)

.segment "VECTORS"
	.addr NMI
	.addr Reset
	.addr IRQ

.segment "CHRDATA"
	.incbin "Jroatch-chr-sheet.chr"
	.incbin "Jroatch-chr-sheet.chr"

