; Function: disk_load
; Description: Loads sectors from the disk into memory using BIOS interrupt 0x13.
; Input:
;   - DX: Drive number (e.g., 0x00 for the first floppy drive)
;   - DH: Number of sectors to read
;   - ES:BX: Memory address to load the sectors into
; Registers used:
;   - AH = 0x02 (BIOS read sectors function)
;   - AL = Number of sectors to read
;   - CH = Cylinder number (set to 0 for simplicity)
;   - CL = Sector number (set to 2, as sector numbering starts at 1)
;   - DH = Head number (set to 0 for simplicity)
;   - SI = Pointer to error message (used in case of failure)

disk_load:
    pusha                ; Save all registers
    
    ; Save the number of sectors to read before we overwrite dh
    mov bl, dh           ; BL = Number of sectors to read (backup)
    
    mov ah, 0x02         ; Set AH to 0x02 for BIOS read sectors function
    mov al, bl           ; AL = Number of sectors to read
    mov ch, 0x00         ; CH = Cylinder number (set to 0)
    mov dh, 0x00         ; DH = Head number (set to 0)
    mov cl, 0x02         ; CL = Sector number (set to 2, as sector numbering starts at 1)
    mov dl, 0x00         ; DL = Drive number (floppy A)
    
    int 0x13             ; Call BIOS interrupt to read sectors

    jc .error            ; If the carry flag is set, an error occurred
    
    ; Compare sectors read (AL) with sectors requested (BL)
    cmp al, bl           ; Check if the number of sectors read matches the requested number
    jne .error           ; If not, jump to the error handler
    
    popa                 ; Restore all registers
    ret                  ; Return to the caller

.error:
    mov si, disk_error_msg  ; Load the address of the error message into SI
    call print_string       ; Print the error message
    jmp $                   ; Hang the system (infinite loop)