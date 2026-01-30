%macro uint32_int_to_str 2 
   
%endmacro

section .data 
section .bss 
    buffer  resb 16
    str_len resb 1
section .text 
    global _start 

_start: 
    xor rcx, rcx    ; used as counter 
    mov eax, 2948576; initialisation must be outside the loop 

    int_to_str: 
    mov ebx, 10     ; base for multiplication  

    xor edx, edx    ; clear the higher 32-bits 
    div ebx         ; divides the 64-bit pair in edx:eax by the operand rbx 
    add edx, 48 

    mov [buffer+rcx], dl 
    inc rcx         ; rcx + 1  
    cmp eax, 0
    jne int_to_str

    ; REVERSE IN PLACE 
    lea rsi, [buffer]           ; left index  
    lea rdi, [buffer + rcx - 1] ; right index  

    .reverse: 
        cmp rsi, rdi 
        jge .write 

        mov al, [rsi] 
        mov bl, [rdi] 
        mov [rsi], bl 
        mov [rdi], al 

        inc rsi
        dec rdi 
    jmp .reverse 

    .write: 
    mov rax, 1
    mov rdi, 1 
    mov rsi, buffer 
    mov rdx, 16 
    syscall 
    

exit: 
    mov rax, 60 
    mov rdi, 1 
    syscall 
