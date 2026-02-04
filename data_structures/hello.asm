%include "_macros.inc" 

section .data 
    msg     db "hello world!!! ", 0 

section .text 
    global _start 

_start: 
    STRLEN msg  
    mov r9, rax 
    
    PRINT msg, r9 
    EXITNORMAL
