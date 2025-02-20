; Global Descriptor Table (GDT)
; The GDT is used in protected mode to define memory segments.
; Each entry in the GDT describes a memory segment, including its base address, size, and access permissions.

gdt_start:
    dq 0x0               ; Null descriptor (required by convention)
    ; The first entry in the GDT is always a null descriptor.
    ; It is not used but must be present.

gdt_code:
    dw 0xFFFF            ; Segment limit (low 16 bits)
    dw 0x0               ; Base address (low 16 bits)
    db 0x0               ; Base address (next 8 bits)
    db 10011010b         ; Access byte: Code segment, executable, readable, accessed
    db 11001111b         ; Flags: 4KB granularity, 32-bit protected mode
    db 0x0               ; Base address (high 8 bits)
    ; This is the code segment descriptor.
    ; It defines a 4GB segment starting at address 0, with executable and readable permissions.

gdt_data:
    dw 0xFFFF            ; Segment limit (low 16 bits)
    dw 0x0               ; Base address (low 16 bits)
    db 0x0               ; Base address (next 8 bits)
    db 10010010b         ; Access byte: Data segment, writable, accessed
    db 11001111b         ; Flags: 4KB granularity, 32-bit protected mode
    db 0x0               ; Base address (high 8 bits)
    ; This is the data segment descriptor.
    ; It defines a 4GB segment starting at address 0, with writable permissions.

gdt_end:
    ; Marks the end of the GDT.

gdt_desc:
    dw gdt_end - gdt_start - 1 ; Size of the GDT (in bytes) minus 1
    dd gdt_start               ; Address of the GDT
    ; The GDT descriptor is used by the LGDT instruction to load the GDT into the CPU.

CODE_SEG equ gdt_code - gdt_start ; Offset of the code segment descriptor
DATA_SEG equ gdt_data - gdt_start ; Offset of the data segment descriptor
; These equates are used to reference the code and data segments in other parts of the code.