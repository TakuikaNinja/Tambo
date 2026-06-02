testsong_header:
	.word testsong_pulse1
	.word testsong_pulse2
	.word testsong_triangle
	.word testsong_noise
	.word testsong_dmc

testsong_pulse1:
	.word testsong_pulse1_invalid
	.word CMD::END

testsong_pulse1_invalid:
	.byte 1, $30, $08, $00, $00 << 3 ; init channel
	.byte 27, $80, $83, $ff, $07 << 3 ; invalid note (ignored)
	.byte 28, $80, $83, $ff, $01 << 3 ; same here
	.byte 0

testsong_dmc:
	.word testsong_dmc_init
	.word CMD::END

testsong_dmc_init:
	.byte 1, $80, $00, $00, $00 ; mute channel
	.byte 0

testsong_pulse2:
	.word testsong_pulse2_pattern0
	.word CMD::JUMP, testsong_pulse2

testsong_pulse2_pattern0:
	.byte 28, $80, $83, C3, $07 << 3
	.byte 28, $80, $83, C4, $01 << 3
	.byte 0

testsong_triangle:
	.word testsong_triangle_pattern0
	.word CMD::JUMP, testsong_triangle

testsong_triangle_pattern0:
	.byte 14, $1f, $00, A2, $01 << 3
	.byte 14, $1f, $00, A3, $01 << 3
;	.byte 14, $1f, $00, A2, $01 << 3
;	.byte 14, $1f, $00, A3, $01 << 3
	.byte 0

testsong_noise:
	.word testsong_noise_pattern0
	.word CMD::JUMP, testsong_noise

testsong_noise_pattern0:
	.byte 14, $00, $00, $0e, $07 << 3
	.byte 14, $00, $00, $00, $00 << 3
	.byte 14, $00, $00, $0b, $07 << 3
	.byte 14, $00, $00, $00, $00 << 3
	.byte 0

