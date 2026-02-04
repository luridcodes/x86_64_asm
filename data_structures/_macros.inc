section .data 
    NEWLINE db 10 

section .text 

; GENERAL MACROS 

; int STRLEN(*char string) 
; results returned in rax 
%macro STRLEN 1 
    mov rdi, %1
    %%loop: 
        cmp [rdi], byte 0 
        je %%return 
        inc rcx 
        inc rdi
        jmp %%loop 

    %%return 
        mov rax, rcx 
%endmacro 

; void PRINT(char *string, int size)  
%macro PRINT 2 
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall 
%endmacro 

; void EXITNORMAL() 
%macro EXITNORMAL 0 
    mov rax, 60 
    mov rdi, 0 
    syscall 
%endmacro 

; **********************************************************
; *                      UINT32_INTTOSTR                   *
; * void uint32(*char buffer)                              * 
; * takes an integer and returns string to buffer          * 
; **********************************************************
; TODO: potential buffer overflow if string cannot 
;       be stored in the buffer provided by the 32_int

%macro UINT32_INTTOSTR 1
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

; *********************************************************
; *                    MEMORY MACROS                      *
; *********************************************************

%macro MMAP_ANON 1 
    mov rax, 9 
    xor rdi, rdi        ; rdi=0 for kernel chosen addr 
    mov rsi, %1         ; size of memory requested
    mov rdx, 3          ; read and write perms 
    mov r10, 0x22       ; MAP_PRIVATE | MAP_ANONYMOUS
    mov r8, -1          ; no fd 
    xor r9, r9          ; kernel chosen page alignment 
    syscall 
%endmacro 
