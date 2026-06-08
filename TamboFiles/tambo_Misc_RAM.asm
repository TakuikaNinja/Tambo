; Tambo Misc RAM (non-ZP)
	channelPatternPointers_Lo: .res 5
	channelPatternPointers_Hi: .res 5
	channelNotePointers_Lo: .res 5
	channelNotePointers_Hi: .res 5
	
	channelLoopCounter1: .res 5
	channelLoopCounter2: .res 5
	
	channelTransposition: .res 5
	sfxTransposition: .res 2 ; normally unused
	
	channelMuteStates: .res 5
	sfxChannelIndexes: .res 2
	
	sfxPointers_Lo: .res 2
	sfxPointers_Hi: .res 2
	
	tamboPauseStatus: .res 1
	tickCounter: .res 1
	sfxTickCounters: .res 2
	speedSetting: .res 1
	speedCounter: .res 1
	
	currentTrack: .res 1
	currentSFX: .res 1

