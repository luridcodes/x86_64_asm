; implementation of a FIFO queue in x86_64 NASM 
; using wrap-around logic
; uses a circular buffer - when end of buffer is reached, it wraps around back to 0 
;   avoids having to move elements around 

section .bss 
    queue_ptr   resd 16     ; reserves 16 DWORDs (32 bits each) for 16x32ints 
    head        resd 1
    tail        resd 1

section .text 
    global _start: 

_start: 
    xor rax,    rax         ; rax is used to acess locations in the queue 
    mov [head], rax         ; initialise head and tail to the same position -- no value stored 
    mov [tail], rax 
