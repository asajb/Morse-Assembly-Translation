ASM = nasm
ASM_FLAGS = -f elf64 -w+all -w+error
LD = ld
LD_FLAGS = --fatal-warnings

TARGET = morse
OBJ = morse.o
SRC = morse.asm

all: $(TARGET)

$(TARGET): $(OBJ)
	$(LD) $(LD_FLAGS) -o $@ $^

$(OBJ): $(SRC)
	$(ASM) $(ASM_FLAGS) -o $@ $<

clean:
	rm -f $(OBJ) $(TARGET)

.PHONY: all clean