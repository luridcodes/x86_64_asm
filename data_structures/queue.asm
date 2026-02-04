; ******************************************************************
; *                        FIFO QUEUE IN ASM                       *
; * implementation of FIFO queue using circular buffer to prevent  *
; * elements from moving around                                    *
; * **CURRENTLY ONLY SUPPORTS uint32 as input                      * 
; ******************************************************************

; TODO make this thing accept negative numbers 

%include "_macros.inc"

section .data 

section .bss 
    queue       resd 16     ; reserves 16 DWORDs (32 bits each) for 16x32ints 
    head        resd 1
    tail        resd 1
    buffer      resd 1

section .text 
    global _start: 

_start: 
    xor rax,    rax         ; rax stores the element number we are trying to access
    mov [head], rax         ; initialise head and tail to the same position -- no value stored 
    mov [tail], rax 

    ; enqueue 70 
    mov edi, 100  
    call enqueue 

    mov edi, 800 
    call enqueue 

    ; dequeue and print  
    call dequeue            ; returns result in RAX which we can print 
    mov [buffer], rax 
    UINT32_INTTOSTR buffer 
    PRINT buffer, 4
    PRINT NEWLINE, 1

    call dequeue 
    mov [buffer], rax 
    UINT32_INTTOSTR buffer 
    PRINT buffer, 4
    PRINT NEWLINE, 1

    ; quie 
    mov rax, 60 
    mov rdi, 0 
    syscall 

enqueue: 
    mov eax, [tail]         ; moves the value of the tail (last value in the queue) 
    mov [queue + rax*4], edi; calculates the address - 4 bytes * position  
    add eax, 1
    cmp eax, 16 
    jl .no_wrap             ; if the buffer is not at the end, just move the index to rax  
    xor eax, eax            ; if the buffer is at the end, restart at 0  

    .no_wrap: 
        mov [tail], eax 
        ret 

dequeue: 
    mov eax, [head] 
    mov ebx, [queue + rax*4] 
    add eax, 1 
    cmp eax, 16 
    jl .no_wrap 
    xor eax, eax 

    .no_wrap: 
        mov [head], eax 
        mov eax, ebx        ; store the return value 
        ret 
