[bits 32]         ; 32-bit protected mode (modern x86 mode)
[extern main]     ; Declare the external symbol 'main' (our kernel's entry point)
global _start

_start:
    ; Set up the stack
    mov esp, kernel_stack + 4096 ; ESP = Stack Pointer
    ; We're setting the stack pointer to the top of the kernel stack
    ; The stack grows downward, so this is the "end" of the stack memory

    ; Call the kernel's main function
    call main
    ; This transfers control to the 'main' function in the kernel
    ; When 'main' returns, execution will continue here

    ; Halt the CPU
    cli                     ; Disable interrupts (again)
    hlt                     ; Halt the CPU
    ; If we ever return here, the CPU will stop executing instructions

section .bss
kernel_stack: resb 4096     ; Reserve 4KB (4096 bytes) for the kernel stack
; The .bss section is used for uninitialized data
; This is where we allocate memory for the stack
; 4KB is a common size for a stack in low-level systems programming