; Function: print_string
; Description: Prints a null-terminated string to the screen using BIOS interrupt 0x10.
; Input: 
;   - DS:SI points to the null-terminated string to print.
; Registers used: 
;   - AH = 0x0E (BIOS teletype output function)
;   - AL = character to print
;   - SI = pointer to the string
;   - PUSHA/POPA used to preserve all registers

print_string:
    pusha                ; Save all registers (we'll restore them later)
    mov ah, 0x0E         ; Set AH to 0x0E for BIOS teletype output

.print_loop:
    lodsb                ; Load the next byte from [SI] into AL and increment SI
    cmp al, 0            ; Check if we've reached the null terminator (AL == 0)
    je .done             ; If yes, jump to the end
    int 0x10             ; Call BIOS interrupt to print the character in AL
    jmp .print_loop      ; Repeat for the next character

.done:
    popa                 ; Restore all registers
    ret                  ; Return to the caller