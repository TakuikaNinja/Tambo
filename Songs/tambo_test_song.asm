tambo_maxTracks:
	.byte 1

;tambo_maxSFX:
;	.byte 1

trackHeaders_Lo:
	.byte <testsong_header
trackHeaders_Hi:
	.byte >testsong_header


testsong_header:
	.word testsong_pulse1
	.word testsong_pulse2
	.word testsong_triangle
	.word testsong_noise
	.word testsong_dmc


testsong_pulse1:
testsong_dmc:
	.word $0000 ; pattern address 0 = end

testsong_pulse2:
	.word testsong_pulse2_pattern0
	.word $00ff, testsong_pulse2 ; loop command?

testsong_pulse2_pattern0:
	.byte 28, $80, $83, C3, $07 << 3
	.byte 28, $80, $83, C4, $01 << 3
	.byte 0 ; duration 0 = terminator

testsong_triangle:
	.word testsong_triangle_pattern0
	.word $00ff, testsong_triangle ; loop command?

testsong_triangle_pattern0:
	.byte 14, $1f, $00, A2, $01 << 3
	.byte 14, $1f, $00, A3, $01 << 3
;	.byte 14, $1f, $00, A2, $01 << 3
;	.byte 14, $1f, $00, A3, $01 << 3
	.byte 0 ; duration 0 = terminator

testsong_noise:
	.word testsong_noise_pattern0
	.word $00ff, testsong_noise ; loop command?

testsong_noise_pattern0:
	.byte 14, $00, $00, $0e, $07 << 3
	.byte 14, $00, $00, $00, $00 << 3
	.byte 14, $00, $00, $0b, $07 << 3
	.byte 14, $00, $00, $00, $00 << 3
	.byte 0 ; duration 0 = terminator

