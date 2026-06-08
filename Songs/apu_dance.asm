; "APU Dance" by TakuikaNinja
; Originally composed using Dn-FT for the Make Literally Anything Jam '26
; https://youtu.be/uk5kF894bVQ

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
	.byte 1, $80, $00, $00, $00 ; mute channel by setting $4010.D7
	.byte 0

apu_dance_blank_pattern:
	.byte 32, 0, 0, CUT, 0
	.byte 0

apu_dance_pulse1:
	.word apu_dance_blank_pattern
	.word apu_dance_blank_pattern
	.word apu_dance_blank_pattern
	
	.word apu_dance_pulse1_pattern0
	.word apu_dance_pulse1_pattern1
	.word apu_dance_pulse1_pattern0
	.word apu_dance_pulse1_pattern2
	.word apu_dance_pulse1_pattern0
	.word apu_dance_pulse1_pattern1
	.word apu_dance_pulse1_pattern3
	.word apu_dance_pulse1_pattern2

	.word apu_dance_pulse1_tom
	
	.word apu_dance_pulse1_pattern0
	.word apu_dance_pulse1_pattern1
	.word apu_dance_pulse1_pattern0
	.word apu_dance_pulse1_pattern2
	.word apu_dance_pulse1_pattern0
	.word apu_dance_pulse1_pattern1
	.word apu_dance_pulse1_pattern3
	.word apu_dance_pulse1_pattern2
	
	.word apu_dance_pulse1_pattern4
	.word apu_dance_pulse1_pattern5
	.word apu_dance_pulse1_pattern4
	.word apu_dance_pulse1_pattern6
	.word apu_dance_pulse1_pattern4
	.word apu_dance_pulse1_pattern5
	.word apu_dance_pulse1_pattern7
	
	.word apu_dance_pulse1_tom

	.word CMD::JUMP, apu_dance_pulse1

apu_dance_pulse1_pattern0:
	.byte 2, $d7, $af, GS4, $04 << 3
	.byte 2, $d3, $08, AS4, $02 << 3
	.byte 2, $d1, $08, AS4, $03 << 3
	.byte 2, $d7, $08, GS4, $04 << 3
	.byte 2, $d7, $08, C5, $04 << 3
	.byte 2, $d3, $08, C5, $02 << 3
	.byte 2, $d7, $a6, C5, $04 << 3
	.byte 2, $d3, $08, AS4, $02 << 3
	.byte 0

apu_dance_pulse1_pattern1:
	.byte 2, $d7, $08, GS4, $04 << 3
	.byte 2, $d3, $08, GS4, $02 << 3
	.byte 2, $d1, $08, GS4, $03 << 3
	.byte 2, $d7, $08, FS4, $04 << 3
	.byte 2, $d7, $08, DS4, $04 << 3
	.byte 2, $d3, $08, DS4, $02 << 3
	.byte 2, $d7, $08, F4, $04 << 3
	.byte 2, $d7, $9f, F4, $04 << 3
	.byte 0

apu_dance_pulse1_pattern2:
	.byte 2, $d7, $08, GS4, $04 << 3
	.byte 2, $d3, $08, GS4, $02 << 3
	.byte 6, $d1, $08, GS4, $03 << 3
	.byte 2, $80, $83, D4, $01 << 3
	.byte 1, $80, $83, C4, $01 << 3
	.byte 1, $80, $83, AS3, $01 << 3
	.byte 2, $80, $83, GS3, $01 << 3
	.byte 0

apu_dance_pulse1_pattern3:
	.byte 2, $d7, $af, GS4, $04 << 3
	.byte 2, $d3, $08, AS4, $02 << 3
	.byte 2, $d1, $08, AS4, $03 << 3
	.byte 2, $d7, $08, GS4, $04 << 3
	.byte 2, $d7, $08, C5, $04 << 3
	.byte 2, $d3, $08, C5, $02 << 3
	.byte 2, $d7, $9f, C5, $04 << 3
	.byte 2, $d3, $08, DS5, $02 << 3
	.byte 0

apu_dance_pulse1_tom:
	.byte 16*4, 0, 0, CUT, 0
	.byte 2, $80, $83, AS3, $01 << 3
	.byte 2, $80, $83, AS3, $01 << 3
	.byte 3, $80, $83, AS3, $01 << 3
	.byte 1, $80, $83, AS3, $01 << 3
	.byte 3, $80, $83, C4, $01 << 3
	.byte 3, $80, $83, AS3, $01 << 3
	.byte 2+16, $80, $83, GS3, $01 << 3
	.byte 2, $80, $83, AS3, $01 << 3
	.byte 2, $80, $83, AS3, $01 << 3
	.byte 3, $80, $83, AS3, $01 << 3
	.byte 1, $80, $83, AS3, $01 << 3
	.byte 3, $80, $83, DS4, $01 << 3
	.byte 3, $80, $83, C4, $01 << 3
	.byte 2+16, $80, $83, GS3, $01 << 3
	.byte 0

apu_dance_pulse1_pattern4:
	.byte 1, $a0, $08, C4, $01 << 3
	.byte 1, $a0, $08, DS4, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, DS4, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, DS4, $01 << 3
	.byte 1, $a0, $08, D4, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, C4, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, AS3, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	.byte 0

apu_dance_pulse1_pattern5:
	.byte 1, $a0, $08, GS3, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, AS3, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, GS3, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, G3, $01 << 3
	.byte 1, $a0, $08, GS3, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, AS3, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $80, $83, C4, $01 << 3
	.byte 1, $80, $83, AS3, $01 << 3
	.byte 2, $80, $83, GS3, $01 << 3
	.byte 0

apu_dance_pulse1_pattern6:
	.byte 1, $a0, $08, GS3, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, AS3, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, GS3, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, G3, $01 << 3
	.byte 1, $a0, $08, DS3, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	.byte 2, $80, $83, D4, $01 << 3
	.byte 1, $80, $83, C4, $01 << 3
	.byte 1, $80, $83, AS3, $01 << 3
	.byte 2, $80, $83, GS3, $01 << 3
	.byte 0

apu_dance_pulse1_pattern7:
	.byte 1, $a0, $08, C4, $01 << 3
	.byte 1, $a0, $08, DS4, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, DS4, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, DS4, $01 << 3
	.byte 1, $a0, $08, D4, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, DS4, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, F4, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	
	.byte 1, $a0, $08, GS4, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, AS4, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, GS4, $01 << 3
	.byte 1, $a0, $08, CUT, $01 << 3
	.byte 1, $a0, $08, G4, $01 << 3
	.byte 1, $a0, $08, DS4, $01 << 3
	.byte 2, $a0, $08, CUT, $01 << 3
	.byte 2, $80, $83, D4, $01 << 3
	.byte 1, $80, $83, C4, $01 << 3
	.byte 1, $80, $83, AS3, $01 << 3
	.byte 2, $80, $83, GS3, $01 << 3
	.byte 0

apu_dance_pulse2:
	.word CMD::SET_LOOP1 | (7 << 8)
apu_dance_pulse2_intro:
	.word apu_dance_pulse2_kick
	.word CMD::LOOP_JUMP1, apu_dance_pulse2_intro

	.word CMD::SET_LOOP1 | (13 << 8)
apu_dance_pulse2_A:
	.word apu_dance_pulse2_pattern0
	.word CMD::LOOP_JUMP1, apu_dance_pulse2_A

	.word apu_dance_pulse2_pattern1
	.word apu_dance_pulse2_pattern1
	.word apu_dance_pulse2_pattern1
	.word apu_dance_pulse2_pattern1

	.word apu_dance_pulse2_pattern0
	.word apu_dance_pulse2_pattern0
	.word apu_dance_pulse2_pattern0
	.word apu_dance_pulse2_pattern0
	
	.word CMD::JUMP, apu_dance_pulse2

apu_dance_pulse2_kick:
	.byte 4, $80, $81, C3, $07 << 3
	.byte 0

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

apu_dance_pulse2_pattern1:
	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, C4, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 1, $16, $b1, C4, $09 << 3
	.byte 1, $16, $b1, D4, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, D4, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, D4, $09 << 3

	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, AS3, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 1, $16, $b1, AS3, $09 << 3
	.byte 1, $16, $b1, AS3, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, AS3, $09 << 3
	.byte 2, $80, $81, C3, $07 << 3
	.byte 2, $16, $b1, GS3, $09 << 3
	.byte 0

apu_dance_triangle:
	.word apu_dance_blank_pattern
	
	.word CMD::SET_LOOP1 | (12 << 8)
apu_dance_triangle_A:
	.word apu_dance_triangle_pattern0
	.word apu_dance_triangle_pattern1
	.word CMD::LOOP_JUMP1, apu_dance_triangle_A
	
	.word apu_dance_triangle_pattern0
	.word apu_dance_triangle_pattern2
	
	.word CMD::TRANSPOSE | (2 << 8) ; +2 semitones
	.word CMD::SET_LOOP1 | (3 << 8)
apu_dance_triangle_B:
	.word apu_dance_triangle_pattern0
	.word apu_dance_triangle_pattern1
	.word CMD::LOOP_JUMP1, apu_dance_triangle_B
	.word CMD::TRANSPOSE | ((128 - 2) << 8) ; -2 semitones
	
	.word CMD::SET_LOOP1 | (3 << 8)
apu_dance_triangle_C:
	.word apu_dance_triangle_pattern0
	.word apu_dance_triangle_pattern1
	.word CMD::LOOP_JUMP1, apu_dance_triangle_C
	
	.word CMD::JUMP, apu_dance_triangle

apu_dance_triangle_pattern0:
	.byte 1, $1f, $00, GS2, $01 << 3
	.byte 3, $1f, $00, AS2, $01 << 3
	.byte 3, $1f, $00, AS2, $01 << 3
	.byte 3, $1f, $00, C3, $01 << 3
	.byte 3, $1f, $00, C3, $01 << 3
	.byte 3, $1f, $00, C3, $01 << 3
	.byte 0

apu_dance_triangle_pattern1:
	.byte 4, $1f, $00, GS2, $01 << 3
	.byte 3, $1f, $00, GS2, $01 << 3
	.byte 3, $1f, $00, GS2, $01 << 3
	.byte 4, $1f, $00, GS2, $01 << 3
	.byte 2, $1f, $00, FS2, $01 << 3
	.byte 0

apu_dance_triangle_pattern2:
	.byte 4, $1f, $00, GS2, $01 << 3
	.byte 3, $1f, $00, GS2, $01 << 3
	.byte 3, $1f, $00, GS2, $01 << 3
	.byte 4, $1f, $00, GS2, $01 << 3
	.byte 2, $1f, $00, AS2, $01 << 3
	.byte 0

apu_dance_noise:
	.word apu_dance_noise_pattern0
	.word apu_dance_noise_pattern1
	
	.word CMD::SET_LOOP1 | (10 << 8)
apu_dance_noise_main:
	.word apu_dance_noise_pattern0
	.word apu_dance_noise_pattern0
	.word apu_dance_noise_pattern0
	.word apu_dance_noise_pattern1
	.word CMD::LOOP_JUMP1, apu_dance_noise_main
	
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

