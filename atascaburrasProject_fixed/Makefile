AS=rgbasm
LD=rgblink
FIX=rgbfix

SRC=src
OUT=game.gb

all:
	$(AS) -o main.o $(SRC)/main.asm
	$(AS) -o render.o $(SRC)/utils/render.asm
	$(AS) -o game.o $(SRC)/system/game_system.asm
	$(LD) -o $(OUT) main.o render.o game.o

clean:
	rm -f *.o *.gb
