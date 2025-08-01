; THis is kinda like the main function of the OS
; (the bootloader begins here)

[org 0x7C00]      ; this means "load $everything at 0x7C00"
; 0x means this is a hexadecimal number
; 0x7C00 is 31488 in decimal
; so basically we're leaving the first 32KB of memory for the BIOS and other stuff
; idk why SPECIFICALLY 32KB, but its just the number IBM chose ages ago and ig now its just convention

[bits 16]         ; 16-bit real mode (OG PC style)

; Setting up Stack Memory
mov bp, 0x8000
; pointer to stack is 0x8000
; this is because stack grows downwards
; this of memory addresses so far like:
; ...
; 0x7C00 - Bootloader starts here
; ...
; 0x8000 - We put our stack here
; ...
; By putting the stack at 0x8000, it grows toward 0x7C00 but won't collide with our bootloader code
; This gives us about 1KB of stack space (0x8000 - 0x7C00 = 0x400 bytes = 1024 bytes)

mov sp, bp        ; Stack grows down, ⬇️ like reverse Mario, basically this just means "Stack pointer = base pointer"

; 📣 Print Boot Message
mov si, hello_msg ; SI stands for "Source Index" - it's one of the general-purpose registers in x86 CPUs
; So right now, SI is pointing to the hello_msg string (which we defined later)
call print_string ; call the print_string function to print it out

; 💾 Load Kernel from disk
mov si, loading_msg
call print_string

mov bx, 0x1000    ; ES:BX = where to load kernel (0x1000:0x0)
mov es, bx        ; ES = segment (0x1000)
mov bx, 0x0       ; BX = offset (0x0)

mov dh, 0x1E      ; Read 30 sectors (15KB kernel) - reduced from 32
call disk_load    ; call the disk_load function to load the kernel
; If disk_load returns, we assume it was successful
; If it fails, it will print an error message and hang

mov si, kernel_loaded_msg
call print_string

; Switch to Protected Mode
cli               ; Disable interrupts before changing CPU mode
lgdt [gdt_desc]   ; Load Global Descriptor Table (GDT)
mov eax, cr0      ; Read control register 0
or eax, 0x1       ; Set PE (Protection Enable) bit
mov cr0, eax

; Jump to protected mode - we'll do the segment setup in kernel
jmp CODE_SEG:init_pm

[bits 32]      ; Switch to 32-bit mode
init_pm:
    mov ax, DATA_SEG  ; Setup data segments
    mov ds, ax
    mov es, ax
    mov ss, ax
    
    jmp CODE_SEG:0x10000  ; Far jump to kernel at 0x10000 with proper code segment

; ------------------- Data -------------------
; Where we define our strings
hello_msg db 'AngaOS Booting...', 0
loading_msg db 13, 10, 'Loading kernel...', 0
kernel_loaded_msg db 13, 10, 'Kernel loaded, switching to protected mode...', 0
disk_error_msg db 13, 10, 'Disk Load Fail', 0

; ------------------- Utilities -------------------
%include "boot/print.asm"
%include "boot/gdt.asm"
%include "boot/disk.asm"

; Bootloader Signature
times 510-($-$$) db 0  ; Padding to 510 bytes
dw 0xAA55              ; Boot signature (0xAA55) - this is what the BIOS looks for to know if this is a bootable disk