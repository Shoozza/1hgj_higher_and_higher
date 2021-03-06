NAME = thegame

all: 32bit

32bit:
	@fpc ${NAME}.dpr -B -l- -MObjFPC -FUobj -FEbin -Fulib/allegro-pas5/lib -dMONOLITH -XM_al_mangled_main -O3

64bit:
	@fpc ${NAME}.dpr -B -l- -MObjFPC -FUobj -FEbin -Fulib/allegro-pas5/lib -dMONOLITH -XM_al_mangled_main -Px86_64

delphi:
	@DCC32 $(NAME).dpr  -l-           -Nobj  -Ebin  -Ulib/allegro-pas5/lib -dMONOLITH -CC

clean:
	@rm -f *.o \
	       *.~* \
	       *.ppu \
	       *.dcu \
	       *.exe \
	       bin/*.exe \
	       obj/*.o \
	       obj/*.a \
	       obj/*.dcu \
	       obj/*.ppu

try: all run

run:
	@cd bin && $(NAME)

.PHONY: all run try clean delphi 32bit 64bit
