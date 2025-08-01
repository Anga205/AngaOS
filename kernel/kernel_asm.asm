[bits 32]
section .text

global _start
global print_char_asm
global print_string_asm
global clear_screen_asm
global read_char_asm

; VGA memory constants
VGA_MEMORY equ 0xB8000
VGA_WIDTH equ 80
VGA_HEIGHT equ 25
VGA_COLOR equ 0x07    ; White on black

; Global variables
section .bss
cursor_pos: resd 1    ; Current cursor position
command_buffer: resb 100  ; Command input buffer
buffer_pos: resd 1    ; Position in command buffer

section .text
_start:
    ; Initialize cursor position
    mov dword [cursor_pos], 0
    mov dword [buffer_pos], 0
    
    ; Clear screen
    call clear_screen_asm
    
    ; Print boot message
    mov esi, kernel_msg
    call print_string_asm
    
    ; Print logo
    call print_logo_asm
    
    ; Print welcome message
    mov esi, welcome_msg
    call print_string_asm
    
    ; Main command loop
main_loop:
    ; Print prompt
    mov esi, prompt_msg
    call print_string_asm
    
    ; Read command
    call read_command
    
    ; Process command
    call process_command
    
    ; Loop back
    jmp main_loop

; Clear the screen
clear_screen_asm:
    pushad
    mov edi, VGA_MEMORY
    mov ecx, VGA_WIDTH * VGA_HEIGHT
    mov ax, (VGA_COLOR << 8) | ' '  ; Space character with color
    rep stosw
    mov dword [cursor_pos], 0
    popad
    ret

; Print a single character
; Input: AL = character
print_char_asm:
    pushad
    
    ; Handle newline
    cmp al, 10  ; '\n'
    je .newline
    
    ; Calculate position in VGA memory
    mov ebx, [cursor_pos]
    mov edi, VGA_MEMORY
    lea edi, [edi + ebx * 2]
    
    ; Write character with attribute
    mov ah, VGA_COLOR
    stosw
    
    ; Increment cursor position
    inc dword [cursor_pos]
    
    ; Check if we need to wrap to next line
    mov eax, [cursor_pos]
    mov edx, 0
    mov ebx, VGA_WIDTH
    div ebx
    cmp edx, 0
    jne .done
    
.newline:
    ; Move to next line
    mov eax, [cursor_pos]
    mov edx, 0
    mov ebx, VGA_WIDTH
    div ebx
    inc eax
    mul ebx
    mov [cursor_pos], eax
    
.done:
    popad
    ret

; Print a null-terminated string
; Input: ESI = pointer to string
print_string_asm:
    pushad
.loop:
    lodsb           ; Load character from ESI into AL
    test al, al     ; Check if null terminator
    jz .done
    call print_char_asm
    jmp .loop
.done:
    popad
    ret

; Print the AngaOS logo
print_logo_asm:
    pushad
    mov esi, logo_line1
    call print_string_asm
    mov esi, logo_line2
    call print_string_asm
    mov esi, logo_line3
    call print_string_asm
    mov esi, logo_line4
    call print_string_asm
    mov esi, logo_line5
    call print_string_asm
    mov esi, logo_line6
    call print_string_asm
    mov esi, logo_line7
    call print_string_asm
    mov esi, logo_line8
    call print_string_asm
    popad
    ret

; Read a character from keyboard (simplified)
read_char_asm:
    ; For now, return a test character
    ; In a real OS, this would read from keyboard controller
    mov al, 'l'  ; Return 'l' for testing
    ret

; Read a command line
read_command:
    pushad
    mov dword [buffer_pos], 0
    mov edi, command_buffer
    
    ; For demonstration, simulate typing "ls"
    mov byte [edi], 'l'
    mov byte [edi + 1], 's'
    mov byte [edi + 2], 0
    mov dword [buffer_pos], 2
    
    ; Echo the command
    mov esi, command_buffer
    call print_string_asm
    
    ; Print newline
    mov al, 10
    call print_char_asm
    
    popad
    ret

; Process the entered command
process_command:
    pushad
    
    ; Check for "ls"
    mov esi, command_buffer
    mov edi, cmd_ls
    call strcmp_asm
    test eax, eax
    jz .cmd_ls
    
    ; Check for "help"
    mov esi, command_buffer
    mov edi, cmd_help
    call strcmp_asm
    test eax, eax
    jz .cmd_help
    
    ; Unknown command
    mov esi, unknown_msg
    call print_string_asm
    mov esi, command_buffer
    call print_string_asm
    mov esi, newline
    call print_string_asm
    jmp .done
    
.cmd_ls:
    mov esi, ls_msg
    call print_string_asm
    jmp .done
    
.cmd_help:
    mov esi, help_msg
    call print_string_asm
    jmp .done
    
.done:
    popad
    ret

; Simple string comparison
; Input: ESI = string1, EDI = string2
; Output: EAX = 0 if equal, non-zero if different
strcmp_asm:
    push esi
    push edi
.loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne .not_equal
    test al, al
    jz .equal
    inc esi
    inc edi
    jmp .loop
.equal:
    xor eax, eax
    jmp .done
.not_equal:
    mov eax, 1
.done:
    pop edi
    pop esi
    ret

; Halt the system
halt:
    cli
    hlt
    jmp halt

section .data
kernel_msg db 'Kernel started successfully!', 10, 0
welcome_msg db 10, '>> AngaOS - Assembly-powered operating system', 10, 'Available commands: ls, help', 10, 0
prompt_msg db 10, 'AngaOS> ', 0
unknown_msg db 'Unknown command: ', 0
newline db 10, 0

; Logo
logo_line1 db 10, '                               ____   _____ ', 10, 0
logo_line2 db '      /\                      / __ \ / ____|', 10, 0
logo_line3 db '     /  \   _ __   __ _  __ _| |  | | (___  ', 10, 0
logo_line4 db '    / /\ \ | ', 39, '_ \ / _` |/ _` | |  | |\___ \ ', 10, 0
logo_line5 db '   / ____ \| | | | (_| | (_| | |__| |____) |', 10, 0
logo_line6 db '  /_/    \_\_| |_|\__, |\__,_|\____/|_____/ ', 10, 0
logo_line7 db '                   __/ |                    ', 10, 0
logo_line8 db '                  |___/                     v1.0.0', 10, 0

; Commands
cmd_ls db 'ls', 0
cmd_help db 'help', 0

; Command responses
ls_msg db 'Directory contents:', 10, '  boot/', 10, '  kernel/', 10, '  README.md', 10, 0
help_msg db 'Available commands:', 10, '  ls - List directory contents', 10, '  help - Show this help', 10, 0
