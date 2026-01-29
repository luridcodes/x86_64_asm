# Tutorial 01: "Hello World" in x86_64 ASM
ASM is notorious for having an overtly complex Hello World program, but it offers a quick and easy way into understanding the fundamentals of ASM programming. If you haven't seen it before, the source code is here: 

```assembly 
section .data 
    msg     db "Hello World", 0 
    msg_len db $-msg 
    
section .text 
    global _start 
    
_start: 
    ; call syscall WRITE to STD_OUT 
    mov rax, 1 
    mov rdi, 1, 
    mov rsi, msg 
    mov rdx, msg_len 
    syscall 
    
    ; exit the program 
    mov rax, 60 
    mov rdi, 1 
    syscall 
``` 
