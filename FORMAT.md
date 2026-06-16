# Tambo Sound Data Format

## Static Data

`tambo_static.asm` defines the number of tracks, the number of SFX, and their associated pointer lists:

```
tambo_maxTracks:
	.byte 2
tambo_maxSFX:
	.byte 3

trackHeaders_Lo:
	.byte <apu_dance_header
	.byte <testsong_header

trackHeaders_Hi:
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
```

## Music Data

Music data for a given track begins with a header. This defines the speed setting for the track, followed by pointers to each channel's pattern data:

```
testsong_header:
	.byte 7 ; speed setting
	; pointers to channel data follows
	.word testsong_pulse1
	.word testsong_pulse2
	.word testsong_triangle
	.word testsong_noise
	.word testsong_dmc
```

Tracks must define pattern data for *all* channels. Unused ones must be muted and terminated manually.

Example for DMC:
```
testsong_dmc:
	.word testsong_dmc_init ; call pattern to init channel
	.word CMD::END ; terminate channel

testsong_dmc_init:
	.byte 1, $80, $00, $00, $00 ; $4010.D7 is used as a mute flag instead of DMC IRQ
	.byte 0
```

### Pattern Data

Addresses/pointers in each channel's pattern data are stored in little endian.

Pattern commands are identified by a pattern address < $8000, and the low byte of the address defines the command. (the high byte may be used as a parameter) Otherwise, these are simply pointers to locations containing note data. 

`tambo_includes.asm` defines the `CMD` namespace to provide shorthands for pattern commands.

For commands other than `END` and `JUMP`, do *not* rely on the exact values defined in the `CMD` namespace.

#### Command Specifications

`END` is defined as 0x00 in the low byte (0x??00), this ends channel processing but does not mute the channel.
Channel muting be done manually within note data.
This command is most often used to end playback for unused channels, or to end a non-looping track.


`JUMP` is defined as 0xFF in the low byte (0x??FF), this jumps to a new location with pattern data.
Example: `.word CMD::JUMP, new_pattern`
This command is most often used for infinite loops.


`TRANSPOSE` adds a signed 7-bit offset to the channel's running transposition. The offset is specified in the high byte, yielding a -64 to +63 semitone range.
- The running transposition is set to 0 when a new track is played.
- Transposing below `A0` or above `B7` is undefined behaviour.
- Noise & DMC are unaffected. (but can safely read/process the command)

Examples:
- `.word CMD::TRANSPOSE | ((128 - 64) << 8) ; -64 semitones`
- `.word CMD::TRANSPOSE | (3 << 8) ; +3 semitones`

This command is most often used for transposing triangle bass patterns.


`SET_LOOP1/2` sets that channel's loop counter: `.word CMD::SET_LOOP | (loop_count << 8)`
The loop count is specified in the high byte, yielding a 0 to 127 range.

`LOOP_JUMP1/2` checks that channel's loop counter:
- If 0, progress to the next pattern address
- Otherwise, decrement the loop counter and perform a JUMP

Example: `.word CMD::LOOP_JUMP1, new_pattern`

This combination is often used for finite loops, such as:
```
apu_dance_pulse2:
	.word CMD::SET_LOOP1 | (7 << 8)
@intro:
	.word apu_dance_pulse2_kick
	.word CMD::LOOP_JUMP1, @intro
	.word CMD::END
```

In this example, `apu_dance_pulse2_kick` will play (7 + 1 = 8) times.

The 1/2 separation is for using separate loop counters in nested loops:
```
nested_example:
	.word CMD::SET_LOOP1 | (3 << 8) ; play @outer_loop 4 times
@outer_loop:
	.word CMD::SET_LOOP2 | (3 << 8) ; play @inner_loop 4 times
@inner_loop:
	.word pattern0
	.word pattern1
	.word CMD::LOOP_JUMP2, @inner_loop

	.word CMD::TRANSPOSE | (2 << 8) ; +2 semitones
	.word CMD::LOOP_JUMP1, @outer_loop

	.word CMD::TRANSPOSE | ((128 - 8) << 8) ; -2*4 = -8 semitones
	.word CMD::JUMP, nested_example ; loop with transposition = 0
```

### Note Data

Each pattern may contain an arbitrary number of notes. A note is defined as the following: `duration (1-255), register 0, register 1, register 2, register 3`

Note durations are counted in units of the speed setting defined by the track header. A duration of 0 terminates the pattern.

#### Channel-specific Register Handling

For pulse & triangle, register 2 contains the note lookup value: `.byte 4, $80, $83, CS3, $07 << 3`
`tambo_includes.asm` provides constants for note indicies. Supported notes are `A0` to `B7`, `CUT` (mute channel), and `REST` (read values but don't write to the registers).
Important: The note lookup assumes that register 3 (length counter) contains all 0s in the lowest 3 bits, hence the use of `<< 3` for length counter values.

For triangle, register 1 is used as a flag to enable automatic linear counter trill: `.byte 2, $03, $01, A3, $01 << 3 ; $4009 != 0: auto linear counter trill (only useful with reload values 1-3)`
Enabling auto linear counter trill on `REST` notes is undefined behaviour.

Noise has no special handling of the register values. (register 1 is unused)

For DMC, setting register 0 to values >= 0x80 will mute the channel instead of enabling DMC IRQs: `.byte 1, $80, $00, $00, $00 ; mute channel by setting $4010.D7`
Additionally, register 1 will only be written to $4011 (direct load) if the value is < 0x80, and skipped otherwise. (This handling is equivalent to the "D-counter" setting in FamiTracker, where a value of "Off" skips the direct load.)

## SFX Data

SFX data defines the channel index (0 = pulse 1, ..., 4 = DMC), the speed setting, then note data in the same format as the music.

```
pulse2_tumble:
	.byte 1 ; channel index (1 = pulse 2)
	.byte 4 ; speed setting
	; note data follows
	.byte 7, $a0, $a2, C4, $01 << 3
	.byte 1, $30, $08, CUT, $00 << 3 ; mute
	.byte 0 ; duration of 0 = terminator
```

Caveats:
- `CUT` and `REST` is supported for pulse/triangle.
- Note transposition is unused. (side effect of the reused note lookup)
- Terminating a SFX will NOT mute the channel. (same as music)
  - It is good practice to include a note cut/mute before terminating SFX.
  - Tip: Use faster speeds (e.g. 2-5) so the muting takes less time.

