%include "macros.asm" 

section .data 
    output_filename db "output.txt",0 
    key_filename    db "key.txt", 0 

    input_len equ 1024 
    W_ARGS_MSG  db "Error: expected one filename argument", 10 
    W_ARGS_MSG_LEN equ $-W_ARGS_MSG

section .bss 
    input_buf   resb 1024
    output_buf  resb 1024       ; output for storing input
    key         resb 1024       ; output for storing key

    ; all these are qwords bcus registers are 64 bits - 
    ; prevents corruption from return value of RAX in FSTAT
    filesize    resq 1
    inputfd     resq 1
    outputfd    resq 1
    keyfd       resq 1

section .text 
    global _start

_start: 
    pop rcx             
    cmp rcx, 2
    je .read
    PRINT_WRONG_ARG

    .read: 
        add rsp, 8
        pop rsi 

    ; open file 
    mov rax, 2
    mov rdi, rsi 
    xor rsi, rsi            ; fl 
    syscall 
    mov [inputfd], rax      ; store full 64 bits to prevent bugs 

    ; read to the input buffer 
    mov rax, 0 
    mov rdi, [inputfd]  
    mov rsi, input_buf
    mov rdx, input_len 
    syscall 
    mov [filesize], rax     ; store size of read
                            ; DO NOT USE RCX OR R10 - DESTROYED BY SYSCALLS 

    call get_random         ; stores random string in KEY the size of filesize 
    call xor_loop
    MAKE_FILE output_filename, [outputfd] 
    MAKE_FILE key_filename, [keyfd] 

    ; print output into output_file
    mov rax, 1
    mov rdi, [outputfd]
    mov rsi, output_buf 
    mov rdx, [filesize]
    syscall 

    ; print key into key_file
    mov rax, 1 
    mov rdi, [keyfd] 
    mov rsi, key
    mov rdx, [filesize] 
    syscall 

    ; close both files 
    CLOSE_FILE outputfd 
    CLOSE_FILE inputfd 
    CLOSE_FILE keyfd

    jmp _exit

_exit: 
    mov rax, 60 
    mov rdi, 67 
    syscall 

get_random: 
    mov rdi, key 
    mov rsi, [filesize]
    xor rdx, rdx 
    mov rax, 318 
    syscall 
    ret

xor_loop: 
    mov rcx, [filesize] 
    mov rsi, input_buf
    mov rdi, key
    mov rdx, output_buf

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
