# Compiler and flags for building the kernel
CC = i686-elf-gcc
CFLAGS = -ffreestanding -nostdlib -Wall -Wextra

# Default target: Build the OS image
all: os-image

# Combine the bootloader and kernel into a single OS image
os-image: boot/boot.bin kernel.bin
	cat $^ > os-image
	truncate -s 1440k os-image

# Assemble the bootloader
boot/boot.bin:
	nasm -f bin boot/boot.asm -o boot/boot.bin

# Link the kernel object files into a single binary
kernel.bin: kernel/kernel_entry.o kernel/kernel.o kernel/screen.o
	i686-elf-ld -o $@ -Ttext 0x1000 $^

# Run the OS in QEMU (emulator)
run:
	qemu-system-i386 -fda os-image

# Clean up build artifacts
clean:
	rm -f *.bin *.o os-image boot/*.bin kernel/*.o

# Declare phony targets (not actual files)
.PHONY: all clean run