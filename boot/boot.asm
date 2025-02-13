; excuse the comments, I'm doing sum hella vibe coding rn
; they're just here for me to remember what I was thinking
; (this is where the bootloader begins btw)


[org 0x7C00]      ; this means "load $everything at 0x7C00"
; 0x means this is a hexadecimal number
; 0x7C00 is 31488 in decimal
; so basically we're leaving the first 32KB of memory for the BIOS and other stuff
; idk why SPECIFICALLY 32KB, but its just the number IBM chose ages ago and ig now its just convention

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
mov sp, bp        ; "Stack pointer = base pointer"

mov si, hello_msg ; SI stands for "Source Index" - it's one of the general-purpose registers in x86 CPUs
; So right now, SI is pointing to the hello_msg string (which we defined later)
call print_string ; Print it out

; Load the kernel from disk
mov bx, 0x1000    ; ES:BX = where to load kernel (0x1000:0x0)
mov es, bx        ; ES = segment (0x1000)
mov bx, 0x0       ; BX = offset (0x0)

mov dh, 0x01      ; Number of sectors to read (1 for now)
call disk_load    ; Load the kernel into memory at 0x1000:0x0

; Jump to the kernel (0x1000:0x0)
jmp 0x1000:0x0    ; Bye bootloader, hello kernel!

; --- Functions ---

print_string:
    lodsb           ; Grab next byte from SI into AL
    or al, al       ; Is AL = 0? (end of string)
    jz done         ; If yes, we out
    mov ah, 0x0E    ; BIOS teletype print char
    int 0x10        ; Call BIOS
    jmp print_string ; Keep printing
done:
    ret             ; Return from function

disk_load:
    ; Loads DH sectors into ES:BX from disk
    pusha           ; Save all registers (we're polite like that)
    push dx         ; Save DX (sector count)

    ; BIOS disk read function (ah = 0x02)
    mov ah, 0x02    ; Read sectors
    mov al, dh      ; Number of sectors to read
    mov ch, 0x00    ; Cylinder 0
    mov dh, 0x00    ; Head 0
    mov cl, 0x02    ; Sector 2 (1st sector is bootloader)
    int 0x13        ; Call BIOS disk interrupt

    jc disk_error   ; If carry flag set, error occurred

    pop dx          ; Restore DX
    cmp al, dh      ; Did we read all sectors we wanted?
    jne disk_error  ; If not, error

    popa            ; Restore all registers
    ret             ; Return, disk loaded successfully

disk_error:
    mov si, error_msg ; Point SI to error message
    call print_string ; Print it
    jmp $            ; Hang forever (rip)

; --- Data ---
hello_msg db 'AngaOS booting...', 0 ; Boot message
error_msg db 'Disk read failed!', 0 ; Error message

times 510-($-$$) db 0  ; Pad to 510 bytes
dw 0xAA55              ; Boot signature (BIOS needs this)