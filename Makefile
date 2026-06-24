GAME=tambo_player
ASSEMBLER=ca65
LINKER=ld65

OBJ_FILES=$(GAME).o

all: $(GAME).nes

$(GAME).nes: $(OBJ_FILES) nes.cfg
	$(LINKER) -o $(GAME).nes -C nes.cfg $(OBJ_FILES) -m $(GAME).map.txt -Ln $(GAME).labels.txt --dbgfile $(GAME).dbg

.PHONY: clean

clean:
	rm -f *.o *.nes *.dbg *.nl *.map.txt *.labels.txt

$(OBJ_FILES): $(wildcard *.asm) $(wildcard TamboFiles/*.asm) $(wildcard Songs/*.asm) Jroatch-chr-sheet.chr Screens/screen.nam.out

%.o:%.asm
	$(ASSEMBLER) $< -g -o $@

Screens/screen.nam.out: Screens/screen.nam
	go run Screens/vramstruct.go Screens/screen.nam 2000 00

