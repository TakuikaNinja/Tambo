; Tambo Misc RAM (non-ZP)
	apuMirrors: .res 4 * 5
	channelNoteCounters: .res 5
;	sfxNoteCountdown: .res 2

	channelPatternPointers_Lo: .res 5
	channelPatternPointers_Hi: .res 5
	channelNotePointers_Lo: .res 5
	channelNotePointers_Hi: .res 5
	
	tamboPauseStatus: .res 1
	tickCounter: .res 1
	
	currentTrack: .res 1
;	currentSFX: .res 1
	
	pulse1Mirrors = apuMirrors
	pulse2Mirrors = apuMirrors+4
	triangleMirrors = apuMirrors+8
	noiseMirrors = apuMirrors+12
	dmcMirrors = apuMirrors+16

