testsong_header:
	.byte 7
	.word testsong_pulse1
	.word testsong_pulse2
	.word testsong_triangle
	.word testsong_noise
	.word testsong_dmc

testsong_pulse1:
	.word testsong_pulse1_invalid
	.word CMD::END

testsong_pulse1_invalid:
	.byte 4, $80, $83, CUT, $07 << 3 ; note cut (i.e. mute channel)
	.byte 4, $80, $83, $ff, $01 << 3 ; invalid note (same as note cut)
	.byte 0

testsong_dmc:
	.word testsong_dmc_init
	.word CMD::END

testsong_dmc_init:
	.byte 1, $80, $00, $00, $00 ; mute channel by setting $4010.D7
	.byte 0

testsong_pulse2:
	.word testsong_pulse2_pattern0
	.word CMD::JUMP, testsong_pulse2

testsong_pulse2_pattern0:
	.byte 4, $80, $83, C3, $07 << 3
	.byte 4, $80, $83, C4, $01 << 3
	.byte 0

testsong_triangle:
	.word testsong_triangle_pattern0
	.word CMD::JUMP, testsong_triangle

testsong_triangle_pattern0:
	.byte 2, $1f, $00, A2, $01 << 3
	.byte 2, $1f, $00, A3, $01 << 3
;	.byte 2, $1f, $00, A2, $01 << 3
;	.byte 2, $1f, $00, A3, $01 << 3
	.byte 0

testsong_noise:
	.word testsong_noise_pattern0
	.word CMD::JUMP, testsong_noise

testsong_noise_pattern0:
	.byte 2, $00, $00, $0e, $07 << 3
	.byte 2, $00, $00, $00, $00 << 3
	.byte 2, $00, $00, $0b, $07 << 3
	.byte 2, $00, $00, $00, $00 << 3
	.byte 0

