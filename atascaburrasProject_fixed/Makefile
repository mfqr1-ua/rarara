
AS=rgbasm
LD=rgblink
FIX=rgbfix

SRC=src
OUT=game.gb

all:
	$(AS) -o main.o $(SRC)/main.asm
	$(AS) -o render.o $(SRC)/utils/render.asm
	$(LD) -o $(OUT) main.o render.o

clean:
	rm -f *.o *.gb
