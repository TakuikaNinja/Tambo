; SFX format:
; - channel index (0-4 = pick a channel, others = don't load SFX)
; - "notes" in a similar format as the music
; *duration is specified in speed 1 rows (1-255, 0 = terminate SFX)
; *note REST & CUT is supported for pulse/triangle
; *transposition is unused (only required by the reused note lookup)
;
; terminating a SFX will NOT mute the channel (same as music)
;
; the SFX slot is automatically picked between 0 or 1 when calling playSFX
; slot 0 takes priority over slot 1 for loading and playing SFX

pulse2_tumble:
	.byte 1
	.byte 28, $a0, $a2, C4, $01 << 3
	.byte 1, $30, $08, CUT, $00 << 3 ; mute
	.byte 0

triangle_skid:
	.byte 2
	.byte 6, $02, $01, A5, $01 << 3
	.byte 1, $80, $00, CUT, $01 << 3 ; mute
	.byte 0

noise_crash:
	.byte 3
	.byte 24, $02, $01, $07, $01 << 3
	.byte 1, $30, $00, $00, $00 << 3 ; mute
	.byte 0

