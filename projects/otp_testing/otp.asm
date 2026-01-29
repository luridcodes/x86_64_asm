; one-time pad in ASM 
%include "macros.asm"

global _start

section .data 
    EXIT_CODE   equ     0
    INPUT:      incbin  "message.txt" 
    INPUT_LEN   equ     $-INPUT

    NEWLINE     db      10   

section .bss 
    KEY     resb INPUT_LEN
    OUTPUT  resb INPUT_LEN
    FINAL   resb INPUT_LEN

section .text 

_start: 
    call get_random             ; generates random no. the size of INPUT_LEN and store in KEY

    PRINT KEY, INPUT_LEN
    PRINT INPUT, INPUT_LEN

    call xor_loop_1             ; bytewise XOR of INPUT and KEY = OUTPUT
    PRINT OUTPUT, INPUT_LEN

    call xor_loop_2             ; bytewise XOR of OUTPUT and KEY = FINAL
    PRINT FINAL, INPUT_LEN

    jmp _exit 

_exit: 
    mov rax, 60 
    mov rdi, 0 
    syscall 

get_random: 
    mov rdi, KEY
    mov rsi, INPUT_LEN
    xor rdx, rdx 
    mov rax, 318
    syscall 

xor_loop_1: 
    mov rcx, INPUT_LEN 
    mov rsi, INPUT 
    mov rdi, KEY 
    mov rdx, OUTPUT 
    
    .repeat: 
        cmp rcx, 0 
        je .return 

        mov al, [rsi]
        xor al, [rdi] 
        mov [rdx], al 

        inc rsi
        inc rdi 
        inc rdx 
        dec rcx 

        jmp .repeat 

    .return: 
        ret

xor_loop_2: 
    mov rcx, INPUT_LEN 
    mov rsi, OUTPUT
    mov rdi, KEY 
    mov rdx, FINAL
    
    .repeat: 
        cmp rcx, 0 
        je .return 

        mov al, [rsi]
        xor al, [rdi] 
        mov [rdx], al 

        inc rsi
        inc rdi 
        inc rdx 
        dec rcx 

        jmp .repeat 

    .return: 
        ret


