# Compiler and flags for building the kernel
CC = gcc
CFLAGS = -m32 -ffreestanding -nostdlib -Wall -Wextra -Ikernel/

# Assembler and flags
ASM = nasm
ASMFLAGS = -f elf32

# Default target: Build the OS image
all: os-image

# Combine the bootloader and kernel into a single OS image
os-image: boot/boot.bin kernel.bin
	cat $^ > os-image
	truncate -s 1440k os-image

# Assemble the bootloader
boot/boot.bin:
	$(ASM) -f bin boot/boot.asm -o boot/boot.bin

# Build kernel components
kernel/kernel_entry.o: kernel/kernel_entry.asm
	$(ASM) $(ASMFLAGS) $< -o $@

kernel/kernel_asm.o: kernel/kernel_asm.asm
	$(ASM) $(ASMFLAGS) $< -o $@

kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel/screen.o: kernel/screen.c
	$(CC) $(CFLAGS) -c $< -o $@

# Link the kernel - now includes assembly kernel
kernel.bin: kernel/kernel_entry.o kernel/kernel_asm.o kernel/kernel.o
	ld -m elf_i386 -o kernel.bin -Ttext 0x10000 -e kernel_entry $^

# Run the OS in QEMU
run:
	qemu-system-i386 -fda os-image

# Clean up
clean:
	rm -f *.bin *.o os-image boot/*.bin kernel/*.o

.PHONY: all clean run