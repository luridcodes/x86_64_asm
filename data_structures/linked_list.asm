%include "_macros.inc" 

SECTION .data
newline: db 10

SECTION .bss
buffer  resq 1
temp    resw 1
first:  resq 1          ; Node *first
N:      resq 1          ; stack size

SECTION .text
GLOBAL _start

; ---------------------------------------------------------
; alloc_node
; rdi = item
; returns rax = Node*
; ---------------------------------------------------------
; FIXME: this is really inefficient - MMAP takes one page 
;        (4kB) per allocation per node; it is way more 
;        economical to rewrite this to MMAP one ENTIRE 
;        buffer and rewrite when full 
alloc_node:
    mov     [temp], rdi

    ; mmap 
    MMAP_ANON 16 

    mov     rcx, [temp]
    mov     [rax], rcx          ; node->item
    mov     qword [rax+8], 0    ; node->next = NULL
    ret

; ---------------------------------------------------------
; isEmpty
; returns rax = 1 if empty, 0 otherwise
; ---------------------------------------------------------
isEmpty:
    mov     rax, [first]
    test    rax, rax
    setz    al
    ret

; ---------------------------------------------------------
; push
; rdi = item
; ---------------------------------------------------------
_push:
    mov     rcx, [first]        ; oldfirst
    call    alloc_node          ; rax = new node
    mov     [rax+8], rcx        ; new->next = oldfirst
    mov     [first], rax        ; first = new
    inc     qword [N]
    ret

; ---------------------------------------------------------
; pop
; returns rax = item
; ---------------------------------------------------------
_pop:
    mov     rbx, [first]        ; node = first
    mov     rax, [rbx]          ; item = node->item
    mov     rcx, [rbx+8]        ; next
    mov     [first], rcx
    dec     qword [N]
    ret

_start:
    xor     rax, rax
    mov     [first], rax
    mov     [N], rax

    mov     rdi, 8 
    call    _push
    mov     rdi, 10
    call    _push
    mov     rdi, 998
    call    _push
    
    mov     rdi, 67 
    call    _push
    
    call    _pop
    mov     [buffer], rax
    UINT32_INTTOSTR buffer 
    STRLEN buffer 
    mov r10, rax 
    PRINT buffer, r10 
    PRINT NEWLINE, 1

    UINT32_INTTOSTR N  
    STRLEN N 
    mov r10, rax 
    PRINT N, r10  

    EXITNORMAL 
