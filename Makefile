# Build System - Glue That Holds Everything Together

# Compiler and flags for building the kernel
CC = i686-elf-gcc
CFLAGS = -ffreestanding -nostdlib -Wall -Wextra

# Default target: Build the OS image
all: os-image

# Combine the bootloader and kernel into a single OS image
os-image: boot/boot.bin kernel.bin
    cat $^ > os-image  # Concatenate bootloader and kernel
    truncate -s 1440k os-image  # Resize to 1.44MB (floppy disk size 🥏)

# Assemble the bootloader
boot/boot.bin:
    nasm -f bin boot/boot.asm -o boot/boot.bin  # Assemble bootloader to binary format

# Link the kernel object files into a single binary
kernel.bin: kernel/kernel_entry.o kernel/kernel.o kernel/screen.o
    i686-elf-ld -o $@ -Ttext 0x1000 $^  # Link kernel at memory address 0x1000 🔗

# Run the OS in QEMU (emulator)
run:
    qemu-system-i386 -fda os-image  # Boot the OS image in a virtual machine 🖥️

# Clean up build artifacts
clean:
    rm -f *.bin *.o os-image boot/*.bin kernel/*.o  # Remove binaries and object files

# Declare phony targets (not actual files)
.PHONY: all clean run