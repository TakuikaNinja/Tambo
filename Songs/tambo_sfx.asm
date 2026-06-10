; SFX format:
; - channel index (0-4 = pick a channel, others = don't load SFX)
; - speed setting (1-255, 0 = don't load SFX)
; - "notes" in a similar format as the music
; *note REST & CUT is supported for pulse/triangle
; *transposition is unused (side effect of the reused note lookup)
;
; terminating a SFX will NOT mute the channel (same as music)
; it is good practice to include a note cut/mute before terminating SFX
; tip: use faster speeds (e.g. 2-5) so the muting takes less time
;
; the SFX slot is automatically picked between 0 or 1 when calling playSFX
; priority in order of highest to lowest:
; 1. the first slot already using that channel index, starting at slot 0
; 2. the first free slot (channel index < 0), starting at slot 0
; if neither condition is met, the SFX will not load

sfx_start:

pulse2_tumble:
	.byte 1
	.byte 4
	.byte 7, $a0, $a2, C4, $01 << 3
	.byte 1, $30, $08, CUT, $00 << 3 ; mute
	.byte 0

triangle_skid:
	.byte 2
	.byte 2
	.byte 3, $02, $01, A5, $01 << 3
	.byte 1, $80, $00, CUT, $01 << 3 ; mute
	.byte 0

noise_crash:
	.byte 3
	.byte 4
	.byte 6, $02, $01, $07, $01 << 3
	.byte 1, $30, $00, $00, $00 << 3 ; mute
	.byte 0

