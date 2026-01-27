; ---- MACROS ---- 

; makes a file
; arg1 - *filename 
; arg2 - buffer to store file desc. 
%macro MAKE_FILE 2 
    ; create a newfile 
    mov rax, 2
    mov rdi, %1
    mov rsi, 2          ; O_RDWR
    or  rsi, 64         ; O_CREAT
    or  rsi, 512        ; O_TRUNC
    mov rdx, 0644o      ; mode (rw-r--r--)
    syscall 
    mov %2, rax 
%endmacro

%macro PRINT_WRONG_ARG 0 
        mov rax, 1
        mov rdi, 1
        mov rsi, W_ARGS_MSG
        mov rdx, W_ARGS_MSG_LEN
        syscall 
        jmp _exit
%endmacro 

%macro CLOSE_FILE 1
    mov rax, 3
    mov rdi, [%1]
    syscall 
%endmacro 
    



