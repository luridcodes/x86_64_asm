%macro PRINT_NEWLINE 0 
    mov rax, 1
    mov rdi, 1
    mov rsi, NEWLINE
    mov rdx, 1
    syscall 
%endmacro

%macro PRINT 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall 
    PRINT_NEWLINE 
%endmacro


