; Tambo ZP RAM
	soundRegion: .res 1
	tamboTemp: .res 1
	channelIndex: .res 1
	sfxSlot: .res 1
	pointer16: .res 2
	
	apuMirrors: .res 4 * 5
	sfxMirrors: .res 4 * 2
	channelNoteCounters: .res 5
	sfxNoteCounters: .res 2
	channelKeyOn: .res 5
	sfxKeyOn: .res 2
	
	pulse1Mirrors = apuMirrors
	pulse2Mirrors = apuMirrors+4
	triangleMirrors = apuMirrors+8
	noiseMirrors = apuMirrors+12
	dmcMirrors = apuMirrors+16

	sfx1Mirrors = sfxMirrors
	sfx2Mirrors = sfxMirrors+4

