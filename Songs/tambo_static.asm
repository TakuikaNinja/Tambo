tambo_maxTracks:
	.byte 2
;tambo_maxSFX:
;	.byte 1

trackHeaders_Lo:
	.byte <apu_dance_header
	.byte <testsong_header

trackHeaders_Hi:
	.byte >apu_dance_header
	.byte >testsong_header

