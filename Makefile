MAKEFLAGS := --jobs=$(shell nproc)
MAKEFLAGS += --output-sync=target

RESULT=os.bin

QEMU=/usr/bin/qemu-system-x86_64
QEMU_FLAGS=-s -boot acd
QEMU_DRIVE_FLAGS=format=raw,index=0,if=floppy
BINUTILS_PREFIX=/usr/local/x86_64-elf-gcc/bin/x86_64-elf

CC=${BINUTILS_PREFIX}-gcc
GDB=${BINUTILS_PREFIX}-gdb

CFLAGS=-c -g -O0 -std=c99 -Wall -Wextra -pedantic -ffreestanding -mno-red-zone

C_SOURCES = $(wildcard kernel/*.c drivers/*.c utils/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h utils/*.h)
OBJ=${C_SOURCES:.c=.o}


.PHONY: all clean run dump debug force


all: ${RESULT}

clean:
	@$(foreach file, $(wildcard boot/*.bin *.elf */*.o), rm -vf $(file);)

force:
	$(MAKE) -B

run: ${RESULT}
	${QEMU} ${QEMU_FLAGS} -drive file=$^,${QEMU_DRIVE_FLAGS}

dump: ${RESULT}
	xxd -ae $^

debug: ${RESULT} kernel.elf
	${QEMU} ${QEMU_FLAGS} -S -drive file=${RESULT},${QEMU_DRIVE_FLAGS} &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"


${RESULT}: boot/bootsect.bin kernel.bin
	cat $^ > $@

kernel.bin: kernel/entry.o ${OBJ}
	${CC} -Wl,--oformat=binary -lgcc -nostdlib -Ttext 0x1000 -e 0x1000 -o $@ $^
	chmod -x $@

kernel.elf: kernel/entry.o ${OBJ}
	${CC} -lgcc -nostdlib -Ttext 0x1000 -e 0x1000 -o $@ $^
	chmod -x $@

boot/bootsect.bin: boot/*.asm
	nasm boot/bootsect.asm -f bin -Ov -o $@

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} $< -o $@

%.o: %.asm
	nasm $< -f elf64 -Ov -o $@
