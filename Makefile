# Compiling for Atari Lynx system
SYS=lynx

# Names of tools
CO=co65
AS=ca65
AR=ar65
CL=cl65
SPRPCK=sprpck
CP=cp
RM=rm -f
ECHO=echo
TOUCH=touch

CODE_SEGMENT=CODE
DATA_SEGMENT=DATA
RODATA_SEGMENT=RODATA
BSS_SEGMENT=BSS

SEGMENTS=--code-name $(CODE_SEGMENT) \
		 --rodata-name $(RODATA_SEGMENT) \
		 --bss-name $(BSS_SEGMENT) \
		 --data-name $(DATA_SEGMENT)

BIN=bin
OBJ=obj

# Flag for assembler
AFLAGS=-I $(CA65_INC) -t $(SYS)

targets = wozmon.lnx
all: $(targets)

%.lnx: %.o
	$(CL) -t $(SYS) -o $*.bin -C lynx-asm.cfg -v -m $*.map $<
	lynxenc $*.bin $*.lyx
	make_lnx $*.lyx -b0 256K -o $@

# Rule for making a *.o file out of a *.s or *.asm file
%.o: %.s
	$(AS) -o $@ $(AFLAGS) $<
%.o: %.asm
	mkdir -p $(OBJ)
	$(AS) -o $@ $(AFLAGS) -l $(OBJ)/$*.lst $<

# Rule for making a *.o file out of a *.bmp file
%.o : %.bmp
	$(SPRPCK) -t6 -p2 $<
	$(ECHO) .global _$(*F) > $*.s
	$(ECHO) .segment \"$(RODATA_SEGMENT)\" >> $*.s
	$(ECHO) _$(*F): .incbin \"$*.spr\" >> $*.s
	$(AS) -o $@ $(AFLAGS) $*.s
	$(RM) $*.s
	$(RM) $*.pal
	$(RM) $*.spr

all: $(target)

clean :
	$(RM) -R $(BIN)
	$(RM) -R $(OBJ)
	$(RM) *.spr
	$(RM) *.s
	$(RM) *.o
	$(RM) *.pal