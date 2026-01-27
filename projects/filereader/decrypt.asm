%include "macros.asm" 

section .data 
    output_filename db "decrypted_msg.txt",0 
    
    input_len equ 1024 
    W_ARGS_MSG db "Error: expected two filename arguments", 10 
    W_ARGS_MSG_LEN equ $-W_ARGS_MSG

section .bss 
    file1_name  resq 1
    file2_name  resq 1
    file1_fd    resq 1
    file2_fd    resq 1  
    outputfd    resq 1
    filesize    resq 1

    file1_buf   resb 1024 
    file2_buf   resb 1024 
    output_buf  resb 1024 

section .text 
    global _start 

_start: 
    ; read CLI arguments 
    pop rcx 
    cmp rcx, 3
    je .read 
    PRINT_WRONG_ARG

    .read: 
        add rsp, 8
        pop rsi 
        mov [file1_name], rsi 

        pop rsi 
        mov [file2_name], rsi 

    ;open both files 
    mov rax, 2
    mov rdi, [file1_name]
    xor rsi, rsi 
    syscall 
    mov [file1_fd], rax 

    mov rax, 2
    mov rdi, [file2_name] 
    xor rsi, rsi 
    syscall 
    mov [file2_fd], rax 

    ;read to both buffers 
    mov rax, 0 
    mov rdi, [file1_fd] 
    mov rsi, file1_buf
    mov rdx, input_len
    syscall 

    mov rax, 0 
    mov rdi, [file2_fd] 
    mov rsi, file2_buf
    mov rdx, input_len
    syscall 
    mov [filesize], rax 


    call xor_loop
    MAKE_FILE output_filename, [outputfd]  
    ; print output to output_file 
    mov rax, 1
    mov rdi, [outputfd] 
    mov rsi, output_buf 
    mov rdx, [filesize] 
    syscall 

    CLOSE_FILE file1_fd 
    CLOSE_FILE file2_fd
    CLOSE_FILE outputfd 

    jmp _exit

_exit: 
    mov rax, 60 
    mov rdi, 1
    syscall 

xor_loop: 
    mov rcx, [filesize] 
    mov rsi, file1_buf
    mov rdi, file2_buf
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
