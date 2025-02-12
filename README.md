command to assemble bootloader boot.asm:

```bash
qemu-system-x86_64 -fda boot.bin
```

and then run it

```bash
qemu-system-x86_64 -fda boot.bin
```

---

compile the kernel

```bash
gcc -ffreestanding -c kernel.c -o kernel.o
```

load the kernal into bootloader

```bash
ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary
```

combine the boot and kernel binaries to make a os image

```bash
cat boot.bin kernel.bin > os_image.bin
```

run the full OS:

```bash
qemu-system-x86_64 -fda os_image.bin
```