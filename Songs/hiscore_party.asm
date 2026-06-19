; "Hi-Score Party" by TakuikaNinja
; Originally composed using Dn-FT for the OST Composing Jam #4 as part of "The Great Synth Heist":
; https://youtu.be/R8sEIPu98zc

hiscore_party_header:
	.byte 7
	.word hiscore_party_pulse1
	.word hiscore_party_pulse2
	.word hiscore_party_triangle
	.word hiscore_party_noise
	.word hiscore_party_dmc

hiscore_party_dmc:
	.word hiscore_party_dmc_perc
	.word CMD::JUMP, hiscore_party_dmc

hiscore_party_dmc_perc:
	.byte 1, $0d, $40, <(hiscore_party_kick >> 6), $09
	.byte 1, $0d, $40, <(hiscore_party_scratch >> 6), $08
	.byte 1, $0d, $40, <(hiscore_party_scratch >> 6), $08
	.byte 1, $0d, $40, <(hiscore_party_scratch >> 6), $08
	.byte 2, $0d, $40, <(hiscore_party_kick >> 6), $09
	.byte 1, $09, $40, <(hiscore_party_scratch >> 6), $08
	.byte 1, $0d, $40, <(hiscore_party_scratch >> 6), $08
	.byte 1, $0d, $40, <(hiscore_party_kick >> 6), $09
	.byte 1, $0d, $40, <(hiscore_party_scratch >> 6), $08
	.byte 2, $0d, $40, <(hiscore_party_scratch >> 6), $08
	.byte 2, $0d, $40, <(hiscore_party_kick >> 6), $09
	.byte 2, $0d, $40, <(hiscore_party_cowbell >> 6), $0a
	.byte 1, $0d, $40, <(hiscore_party_kick >> 6), $09
	.byte 1, $0d, $40, <(hiscore_party_scratch >> 6), $08
	.byte 2, $09, $40, <(hiscore_party_scratch >> 6), $08
	.byte 2, $0d, $40, <(hiscore_party_kick >> 6), $09
	.byte 2, $09, $40, <(hiscore_party_scratch >> 6), $08
	.byte 2, $0d, $40, <(hiscore_party_kick >> 6), $09
	.byte 1, $0d, $40, <(hiscore_party_cowbell >> 6), $0a
	.byte 1, $0d, $40, <(hiscore_party_cowbell >> 6), $0a
	.byte 1, $0d, $40, <(hiscore_party_kick >> 6), $09
	.byte 1, $0d, $40, <(hiscore_party_scratch >> 6), $08
	.byte 1, $0d, $40, <(hiscore_party_cowbell >> 6), $0a
	.byte 1, $09, $40, <(hiscore_party_scratch >> 6), $08
	.byte 0

hiscore_party_pulse1:
	.word hiscore_party_pulse_blank
	.word hiscore_party_pulse_blank
	.word hiscore_party_pulse_blank
	
	.word CMD::SET_LOOP1 | (5 << 8)
hiscore_party_pulse1_loop:
	.word hiscore_party_pulse1_pattern
	.word CMD::LOOP_JUMP1, hiscore_party_pulse1_loop
	
	.word CMD::JUMP, hiscore_party_pulse1

hiscore_party_pulse1_pattern:
	.byte 2, $15, $87, D4, $01 << 3
	.byte 2, $55, $87, D4, $01 << 3
	.byte 6, $95, $f1, D4, $01 << 3
	.byte 4, $55, $f1, D4, $01 << 3
	.byte 2, $d5, $fa, D4, $01 << 3
	.byte 1, $15, $87, D4, $01 << 3
	.byte 1, $15, $87, D4, $01 << 3
	.byte 1, $55, $87, D4, $01 << 3
	.byte 1, $55, $87, D4, $01 << 3
	.byte 6, $95, $f1, D4, $01 << 3
	.byte 4, $55, $f1, D4, $01 << 3
	.byte 2, $d5, $f1, CS4, $01 << 3
	
	.byte 2, $15, $87, D4, $01 << 3
	.byte 2, $55, $f3, D4, $01 << 3
	.byte 6, $95, $f1, D4, $01 << 3
	.byte 4, $55, $f1, D4, $01 << 3
	.byte 2, $d5, $fa, D4, $01 << 3
	.byte 1, $15, $87, D4, $01 << 3
	.byte 1, $15, $87, D4, $01 << 3
	.byte 2, $55, $f3, D4, $01 << 3
	.byte 6, $95, $f1, D4, $01 << 3
	.byte 2, $55, $f1, D4, $01 << 3
	.byte 2, $95, $f3, D4, $01 << 3
	.byte 2, $d5, $f1, CS4, $01 << 3
	.byte 0

hiscore_party_pulse2:
	.word hiscore_party_pulse_blank
	
	.word CMD::SET_LOOP1 | (1 << 8)
hiscore_party_pulse2_loop:
	.word hiscore_party_pulse_blank
	
	.word CMD::SET_LOOP2 | (5 << 8)
@inner:
	.word hiscore_party_pulse2_pattern0
	.word hiscore_party_pulse2_pattern0
	.word hiscore_party_pulse2_pattern0
	.word hiscore_party_pulse2_pattern0
	.word hiscore_party_pulse2_pattern0
	.word hiscore_party_pulse2_pattern0
	.word hiscore_party_pulse2_pattern0
	.word hiscore_party_pulse2_pattern1
	.word CMD::LOOP_JUMP2, @inner
	.word CMD::LOOP_JUMP1, hiscore_party_pulse2_loop

	.word CMD::JUMP, hiscore_party_pulse2

hiscore_party_pulse_blank:
	.byte 64, $30, $08, CUT, $00 << 3
	.byte 0

hiscore_party_pulse2_pattern0:
	.byte 2, $80, $82, C3, $01 << 3
	.byte 1, $97, $b1, D3, $09 << 3
	.byte 1, $93, $b1, D3, $09 << 3
	.byte 0

hiscore_party_pulse2_pattern1:
	.byte 2, $80, $82, C3, $01 << 3
	.byte 1, $97, $b1, CS3, $09 << 3
	.byte 1, $93, $b1, CS3, $09 << 3
	.byte 0

hiscore_party_triangle:
	.word hiscore_party_triangle_bass
	.word hiscore_party_triangle_bass_endA
	.word hiscore_party_triangle_bass
	.word hiscore_party_triangle_bass_endB
	.word CMD::JUMP, hiscore_party_triangle

hiscore_party_triangle_bass:
	.byte 3, $40, $00, D2, $01 << 3
	.byte 2, $20, $00, D3, $01 << 3
	.byte 1, $40, $00, D2, $01 << 3
	.byte 1, $40, $00, F2, $01 << 3
	.byte 1, $40, $00, G2, $01 << 3
	.byte 2, $40, $00, A2, $01 << 3
	.byte 2, $20, $00, F2, $01 << 3
	.byte 2, $40, $00, D2, $01 << 3
	.byte 0
	
hiscore_party_triangle_bass_endA:
	.byte 2, $20, $00, G2, $01 << 3
	.byte 0

hiscore_party_triangle_bass_endB:
	.byte 2, $20, $00, CS2, $01 << 3
	.byte 0

hiscore_party_noise:
	.word hiscore_party_noise_intro
	
	.word CMD::SET_LOOP1 | (3 << 8)
hiscore_party_noise_perc_loopA:
	.word CMD::SET_LOOP2 | (6 << 8)
@inner:
	.word hiscore_party_noise_perc0
	.word CMD::LOOP_JUMP2, @inner
	.word hiscore_party_noise_perc1
	.word CMD::LOOP_JUMP1, hiscore_party_noise_perc_loopA
	
	.word hiscore_party_noise_crash
	
	.word CMD::SET_LOOP1 | (1 << 8)
hiscore_party_noise_perc_loopB:
	.word CMD::SET_LOOP2 | (6 << 8)
@inner:
	.word hiscore_party_noise_perc0
	.word CMD::LOOP_JUMP2, @inner
	.word hiscore_party_noise_perc1
	.word CMD::LOOP_JUMP1, hiscore_party_noise_perc_loopB
	
	.word CMD::JUMP, hiscore_party_noise

hiscore_party_noise_crash:
	.byte 64, $07, $00, $03, $01 << 3

; fall through
hiscore_party_noise_intro:
	.byte 32+24, $30, $00, $00, $00 << 3
	.byte 1, $01, $00, $07, $01 << 3
	.byte 2, $01, $00, $07, $01 << 3
	.byte 1, $01, $00, $07, $01 << 3
	.byte 2, $01, $00, $07, $01 << 3
	.byte 2, $01, $00, $07, $01 << 3
	.byte 0

hiscore_party_noise_perc0:
	.byte 2, $00, $00, $00, $03 << 3
	.byte 2, $02, $00, $01, $01 << 3
	.byte 2, $01, $00, $07, $01 << 3
	.byte 2, $02, $00, $01, $01 << 3
	.byte 0

hiscore_party_noise_perc1:
	.byte 2, $00, $00, $00, $03 << 3
	.byte 2, $02, $00, $01, $01 << 3
	.byte 2, $01, $00, $07, $01 << 3
	.byte 2, $01, $00, $07, $01 << 3
	.byte 0


