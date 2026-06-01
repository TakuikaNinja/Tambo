; RAM

; zeropage
.segment "ZEROPAGE"
	temp: .res 16 ; temp memory
	NMIReady: .res 1
	NeedDraw: .res 1
	NeedPPUMask: .res 1
	PPU_MASK_MIRROR: .res 1
	PPU_CTRL_MIRROR: .res 1
	Mode: .res 1
	Buttons: .res 4
	
	.include "TamboFiles/tambo_ZP_RAM.asm"

; rest of memory
.segment "BSS"
	stack: .res 256
	oam: .res 256
	vram_buffer: .res 256
	
	.include "TamboFiles/tambo_Misc_RAM.asm"

