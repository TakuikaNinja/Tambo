# Tambo

Tambo (田んぼ, Japanese for rice field) is a sound driver for the NES/FC. The name rhymes with "dumbo" because the note data is barely above the level of a compressed register log.

The idea came to be after composing [APU Dance](https://www.youtu.be/uk5kF894bVQ) in Dn-FamiTracker with hardware-driven sound design. This driver was developed with such limitations in mind, along with size reduction features not seen in popular homebrew sound drivers.

## Features

- Up to 256 tracks and 256 SFX.
- 2 SFX slots, each picking a single arbitrary channel.
- Track pause/resume and stop functions.
- Full support for all the 2A03 channels & hardware features (except DMC IRQ):
  - Envelope (+ loop) or constant volume
  - Sweep
  - Length/linear counter
  - DPCM
- Pitch & tempo adjustment based on TV system/console region. (NTSC/PAL/Dendy)
- A0 to B7 note range.
- Note cut/rest support for pulse & triangle.
- Automatic linear counter trill setting for triangle.
- Arbitrary number of notes within each pattern. (note duration of 0 = terminate pattern)
- Pattern-level commands to aid with song size reduction:
  - Pattern jump/Infinite loop
  - Finite loop (2 are provided to accomplish 1 level of nesting)
  - Note transposition (pulse/triangle only)
  - End song (for a given channel)

## Limitations

- **No instruments or macros.** The register values for a given channel are set *once* per note.
- Each note always uses 5 bytes (duration + register/note values), so note cuts/rests tend to waste space.
- Tempo handling is equivalent to using Tempo 150 and setting the speed once per song in FamiTracker.
- Driver and sound data must be located at CPU $8000 onwards. (required by pattern commands)
- Chaining pattern commands is somewhat expensive.
- Each song must use all channels. Unused ones must be manually muted/terminated.
- SFX are finite length and should be manually muted within SFX data.

## Usage

Tambo is primarily developed and intended for cc65 projects. Support for other assemblers is out-of-scope.

### Folder Structure

The below folder structure should aid with organising the sound driver usage:

- `TamboFiles/`
  - `tambo.asm` - driver source (must place at $8000 onwards)
  - `tambo_includes.asm` - driver constants
  - `tambo_Misc_RAM.asm` - non-zeropage variables
  - `tambo_ZP_RAM.asm` - zeropage variables ($0000-$00FF)
- `Songs/`
  - `Samples/` contains `.dmc` sample files, if needed
  - `tambo_dpcm.asm` - DPCM definitions, if needed (must place at $C000 onwards)
  - `tambo_static.asm` - track/SFX counts and pointers
  - `tambo_sfx.asm` - SFX data (must place at $8000 onwards)
  - remaining `.asm` files contain song data (must place at $8000 onwards)

Just `.include` the files at the appropriate places within a project and it should work. It should be similar to drivers such as Sabre.

### Interface

1. `jsr tambo_initAPU` after reset tasks with the region setting in `soundRegion` (0 = NTSC, 1 = PAL, 2 = Dendy, others = fall back to NTSC). A/X/Y are clobbered.
2. `jsr tambo_soundUpdate` once per frame to update the audio. A/X/Y are clobbered.

`jsr tambo_playTrack` plays the track specified in `currentTrack`. A is clobbered, X/Y are preserved.

`jsr tambo_playSFX` plays the SFX specified in `currentSFX`. A is clobbered, X/Y are preserved.

The SFX slot is automatically picked between 0 or 1. Priority in order of highest to lowest:
1. The first slot using the same channel as the new SFX, starting at slot 0
2. The first free slot, starting at slot 0

If neither condition is met, the SFX will not load.

`jsr tambo_pauseTrack` pauses or resumes the currently playing track. A is clobbered, X/Y are preserved.

Note that SFX will be stopped entirely when pausing the track. If you wish to play a pause jingle, play the SFX *after* pausing the track.

`jsr tambo_stopTrack` stops the currently playing track and SFX. A is clobbered, X/Y are preserved.

## Sound Format

See `FORMAT.md` (TODO) and/or the demo files in `Songs`.

## Replayer

A replayer program is provided. It displays a raster bar to help benchmark the driver performance.

### Controls

- Left/Right plays a new song.
- Start pauses/resumes playback.
- Select stops all audio.
- A/B plays SFX.

### Building

The CC65 toolchain is required to build the replayer program: https://cc65.github.io/
A simple `make` should then work. RAM/ROM usage is logged during the process.

## Acknowledgements

- This dumb driver idea would not have happened without the catchy tunes from early first-party titles composed by Hip Tanaka and Yukio Kaneoka.
- The pattern parsing and pitch/tempo implementation was inspired by [Sabre](https://github.com/CutterCross/Sabre).
  - Its replayer was also used as a baseline for performance testing.
- `Jroatch-chr-sheet.chr` was converted from the following placeholder CHR sheet: https://www.nesdev.org/wiki/File:Jroatch-chr-sheet.chr.png
  - It contains tiles from Generitiles by Drag, Cavewoman by Sik, and Chase by shiru.
- The NESdev Wiki, Forums, and Discord have been a massive help. Kudos to everyone keeping this console generation alive!


