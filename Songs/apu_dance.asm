apu_dance_header:
	.byte 7
	.word apu_dance_pulse1
	.word apu_dance_pulse2
	.word apu_dance_triangle
	.word apu_dance_noise
	.word apu_dance_dmc

apu_dance_dmc:
	.word apu_dance_dmc_init
	.word CMD::END

apu_dance_dmc_init:
	.byte 1, $80, $00, $00, $00 ; mute channel
	.byte 0

apu_dance_blank_pattern:
	.byte 16, 0, 0, REST, 0
	.byte 0

apu_dance_pulse1:
	.word apu_dance_pulse1_invalid
	.word CMD::END

apu_dance_pulse1_invalid:
	.byte 4, $80, $83, $ff, $07 << 3 ; invalid note (ignored)
	.byte 4, $80, $83, $ff, $01 << 3 ; same here
	.byte 0

apu_dance_pulse2:
	.word apu_dance_pulse2_pattern0
	.word CMD::JUMP, apu_dance_pulse2

apu_dance_pulse2_pattern0:
	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, AS3, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 1, $16, $b1, AS3, $09 << 3
	.byte 1, $16, $b1, C4, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, C4, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, C4, $09 << 3

	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, GS3, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 1, $16, $b1, GS3, $09 << 3
	.byte 1, $16, $b1, GS3, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, GS3, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $c1, FS3, $09 << 3
	.byte 0

apu_dance_triangle:
	.word apu_dance_triangle_pattern0
	.word CMD::JUMP, apu_dance_triangle

apu_dance_triangle_pattern0:
	.byte 1, $1f, $00, GS2, $01 << 3
	.byte 3, $1f, $00, AS2, $01 << 3
	.byte 3, $1f, $00, AS2, $01 << 3
	.byte 3, $1f, $00, C3, $01 << 3
	.byte 3, $1f, $00, C3, $01 << 3
	.byte 3, $1f, $00, C3, $01 << 3
	
	.byte 4, $1f, $00, GS2, $01 << 3
	.byte 3, $1f, $00, GS2, $01 << 3
	.byte 3, $1f, $00, GS2, $01 << 3
	.byte 4, $1f, $00, GS2, $01 << 3
	.byte 2, $1f, $00, FS2, $01 << 3
	.byte 0

apu_dance_noise:
	.word apu_dance_noise_pattern0
	.word apu_dance_noise_pattern0
	.word apu_dance_noise_pattern0
	.word apu_dance_noise_pattern1
	.word CMD::JUMP, apu_dance_noise

apu_dance_noise_pattern0:
	.byte 1, $00, $00, $0e, $07 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $01, $00 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $0b, $07 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $01, $00 << 3
	.byte 1, $00, $00, $0b, $03 << 3
	.byte 1, $00, $00, $0e, $07 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $01, $00 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $0b, $07 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $01, $00 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 0

apu_dance_noise_pattern1:
	.byte 1, $00, $00, $0e, $07 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $01, $00 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $0b, $07 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $01, $00 << 3
	.byte 1, $00, $00, $0b, $03 << 3
	.byte 1, $00, $00, $0e, $07 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $01, $00 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $0b, $07 << 3
	.byte 1, $00, $00, $00, $03 << 3
	.byte 1, $00, $00, $0b, $05 << 3
	.byte 1, $00, $00, $0b, $03 << 3
	.byte 0

