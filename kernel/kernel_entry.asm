[bits 32]
[extern _start]     ; Our assembly kernel main function
global kernel_entry

kernel_entry:
    ; Set up the stack
    mov esp, kernel_stack + 4096
    
    ; Jump directly to assembly kernel
    jmp _start
    
    ; Halt if we ever return
    cli
    hlt

section .bss
kernel_stack: resb 4096