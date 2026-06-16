; Tambo constants

; Sound region
.enum REGION
	NTSC = 0
	PAL
	DENDY
	BAD
.endenum

; equivalent to FamiTracker's Tempo mode tempo
TEMPO = 150

; Pattern commands
; commands are identified by a pattern address < $8000
; the low byte of the address defines the command (high byte may be used as a parameter)
; Command specifications:

; END is defined as $00 in the low byte ($xx00), this ends channel processing
; this is most often used to end playback for unused channels,
; or to end a non-looping track

; JUMP is defined as $ff in the low byte ($xxff), this jumps to a new pattern
; Example: .word CMD::JUMP, new_pattern
; this is most often used for infinite loops

; TRANSPOSE adds a signed 7-bit offset to the channel's running transposition
; offset is stored in the high byte, yielding a -64 to +63 range
; *the running transposition is set to 0 when a new track is played
; *transposing below A0 or above B7 is undefined behaviour
; *noise & DMC are unaffected (but can read/process the command)
; Example 1: .word CMD::TRANSPOSE | ((128 - 64) << 8) ; -64 semitones
; Example 2: .word CMD::TRANSPOSE | (3 << 8) ; +3 semitones
; this is most often used for transposing triangle bass patterns

; loop commands
; SET_LOOP1/2 sets that channel's loop counter to the value in the high byte
; Example: .word CMD::SET_LOOP | (loop_count << 8) ; loop_count is 0-127
;
; LOOP_JUMP1/2 checks that channel's loop counter:
; - if 0, progress to the next pattern address
; - otherwise, decrement the loop counter and perform a JUMP
; Example: .word CMD::LOOP_JUMP1, new_pattern
;
; this combination is often used for finite loops, such as:
; 
;	apu_dance_pulse2:
;		.word CMD::SET_LOOP1 | (7 << 8)
;	@intro:
;		.word apu_dance_pulse2_kick
;		.word CMD::LOOP_JUMP1, @intro
;		.word CMD::END
;
; in this example, apu_dance_pulse2_kick will play (7 + 1 = 8) times
;
; the 1/2 separation is for using separate loop counters in nested loops:
;
;   nested_example:
;		.word CMD::SET_LOOP1 | (3 << 8) ; play @outer_loop 4 times
;	@outer_loop:
;		.word CMD::SET_LOOP2 | (3 << 8) ; play @inner_loop 4 times
;	@inner_loop:
;		.word pattern0
;		.word pattern1
;		.word CMD::LOOP_JUMP2, @inner_loop
;
;		.word CMD::TRANSPOSE | (2 << 8) ; +2 semitones
;		.word CMD::LOOP_JUMP1, @outer_loop
;
;		.word CMD::TRANSPOSE | ((128 - 8) << 8) ; -2*4 = -8 semitones
;		.word CMD::JUMP, nested_example ; loop with transposition = 0

; For commands other than END and JUMP, do NOT rely on the exact values
; commands commented out below are reserved for future versions
.enum CMD
	END = $0000
	SET_LOOP1 = $0001
	LOOP_JUMP1 = $0002
	TRANSPOSE = $0080
	SET_LOOP2 = $00fd
	LOOP_JUMP2 = $00fe
	JUMP = $00ff
.endenum

; Note indicies
A0  = 0
AS0 = 1
B0  = 2
C1  = 3
CS1 = 4
D1  = 5
DS1 = 6
E1  = 7
F1  = 8
FS1 = 9
G1  = 10
GS1 = 11
A1  = 12
AS1 = 13
B1  = 14
C2  = 15
CS2 = 16
D2  = 17
DS2 = 18
E2  = 19
F2  = 20
FS2 = 21
G2  = 22
GS2 = 23
A2  = 24
AS2 = 25
B2  = 26
C3  = 27
CS3 = 28
D3  = 29
DS3 = 30
E3  = 31
F3  = 32
FS3 = 33
G3  = 34
GS3 = 35
A3  = 36
AS3 = 37
B3  = 38
C4  = 39
CS4 = 40
D4  = 41
DS4 = 42
E4  = 43
F4  = 44
FS4 = 45
G4  = 46
GS4 = 47
A4  = 48
AS4 = 49
B4  = 50
C5  = 51
CS5 = 52
D5  = 53
DS5 = 54
E5  = 55
F5  = 56
FS5 = 57
G5  = 58
GS5 = 59
A5  = 60
AS5 = 61
B5  = 62
C6  = 63
CS6 = 64
D6  = 65
DS6 = 66
E6  = 67
F6  = 68
FS6 = 69
G6  = 70
GS6 = 71
A6  = 72
AS6 = 73
B6  = 74
C7  = 75
CS7 = 76
D7  = 77
DS7 = 78
E7  = 79
F7  = 80
FS7 = 81
G7  = 82
GS7 = 83
A7  = 84
AS7 = 85
B7  = 86
REST = 87
CUT = 88

