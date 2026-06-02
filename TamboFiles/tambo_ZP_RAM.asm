; Tambo ZP RAM
	soundRegion: .res 1
	tamboTemp: .res 1
	channelIndex: .res 1
	pointer16: .res 2
	
	apuMirrors: .res 4 * 5
	channelNoteCounters: .res 5
;	sfxNoteCounters: .res 2
	channelKeyOn: .res 5
	
	pulse1Mirrors = apuMirrors
	pulse2Mirrors = apuMirrors+4
	triangleMirrors = apuMirrors+8
	noiseMirrors = apuMirrors+12
	dmcMirrors = apuMirrors+16

