AS=rgbasm
LD=rgblink
FIX=rgbfix

SRC=src
OUT=game.gb

all:
	$(AS) -o header.o $(SRC)/header.asm
	$(AS) -o main.o $(SRC)/main.asm
	$(AS) -o render.o $(SRC)/utils/render.asm
	$(AS) -o collisions.o $(SRC)/system/collisions.asm
	$(AS) -o game.o $(SRC)/system/game_system.asm
	$(AS) -o audio.o $(SRC)/system/audio_system.asm
	$(LD) -o $(OUT) header.o main.o render.o collisions.o game.o audio.o
	$(FIX) -v -p 0 -t UNDERFLOW $(OUT)

clean:
	rm -f *.o *.gb
