tambo_maxTracks:
	.byte 2
;tambo_maxSFX:
;	.byte 1

trackHeaders_Lo:
	.byte <testsong_header
	.byte <apu_dance_header
trackHeaders_Hi:
	.byte >testsong_header
	.byte >apu_dance_header

