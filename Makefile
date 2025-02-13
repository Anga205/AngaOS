BOOTLOADER = boot.bin
KERNEL = kernel.bin
ISO = AngaOS.iso

ASM = nasm
CC = gcc
LD = ld
QEMU = qemu-system-x86_64

ASM_FLAGS = -f bin
CC_FLAGS = -m32 -ffreestanding -nostdlib
LD_FLAGS = -m elf_i386 -Ttext 0x1000 --oformat binary

all: run

$(BOOTLOADER): boot.asm
	$(ASM) $(ASM_FLAGS) -o $@ $<

$(KERNEL): kernel.c
	$(CC) $(CC_FLAGS) -o kernel.o -c $<
	$(LD) $(LD_FLAGS) -o $@ kernel.o

$(ISO): $(BOOTLOADER) $(KERNEL)
	dd if=/dev/zero of=floppy.img bs=512 count=2880
	dd if=$(BOOTLOADER) of=floppy.img conv=notrunc
	dd if=$(KERNEL) of=floppy.img bs=512 seek=1 conv=notrunc
	mkisofs -o $@ -b floppy.img .

run: $(ISO)
	$(QEMU) -cdrom $<

clean:
	rm -f $(BOOTLOADER) $(KERNEL) $(ISO) floppy.img kernel.o

.PHONY: all run clean
