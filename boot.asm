; excuse the comments, I'm doing sum hella vibe coding rn
; they're just here for me to remember what I was thinking

; this is where the bootloader begins btw
[org 0x7C00]      ; BIOS loads us here, we vibing at 0x7C00

; Set up the stack (so calls work properly)
mov bp, 0x8000    ; Stack base pointer somewhere safe
mov sp, bp        ; Stack pointer = base pointer

; Print boot message
mov si, hello_msg ; SI points to the welcome message
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