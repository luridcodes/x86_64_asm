section .data 
    NEWLINE db 10 

section .text 

; *************************************************
; *              UINT32_STRTOINT                  * 
; * void uint32(*char buffer)                     * 
; * takes an integer and returns string to buffer * 
; *************************************************

%macro UINT32_STRTOINT 1
    xor rcx, rcx 
    mov eax, [%1] 

    %%int_to_str: 
        mov ebx, 10 

        xor edx, edx 
        div ebx
        add edx, 48 

        mov [%1+rcx], dl 
        inc rcx 
        cmp eax, 0 
        jne %%int_to_str

    ; REVERSE STRING IN PLACE 
    mov rsi, %1
    lea rdi, [%1+ rcx - 1]

    %%reverse: 
        cmp rsi, rdi 
        jge %%return 

        mov al, [rsi] 
        mov bl, [rdi] 
        mov [rsi], bl 
        mov [rdi], al 

        inc rsi
        dec rdi 
        jmp %%reverse 

    %%return: 
    
%endmacro 

; PRINT 
%macro PRINT 2 
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall 
%endmacro 
