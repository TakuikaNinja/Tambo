tambo_maxTracks:
	.byte 3
tambo_maxSFX:
	.byte 3

trackHeaders_Lo:
	.byte <hiscore_party_header
	.byte <apu_dance_header
	.byte <testsong_header

trackHeaders_Hi:
	.byte >hiscore_party_header
	.byte >apu_dance_header
	.byte >testsong_header

sfxHeaders_Lo:
	.byte <pulse2_tumble
	.byte <triangle_skid
	.byte <noise_crash

sfxHeaders_Hi:
	.byte >pulse2_tumble
	.byte >triangle_skid
	.byte >noise_crash

