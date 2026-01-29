; nasm -f elf64 fbwrite.asm && ld -o fbwrite fbwrite.o
; Run as root in TTY: ./fbwrite

section .data
    fbfile db "/dev/fb0", 0

    ; timespec struct for nanosleep: { seconds, nanoseconds }
    ts_sec dq 5              ; sleep 5 seconds
    ts_nsec dq 0

section .bss
    fbfd resq 1
    fbptr resq 1

section .text
    global _start

_start:
    ; open("/dev/fb0", O_RDWR)
    mov rax, 2              ; sys_open
    mov rdi, fbfile
    mov rsi, 2              ; O_RDWR
    syscall
    mov [fbfd], rax

    ; mmap framebuffer
    mov rax, 9              ; sys_mmap
    xor rdi, rdi
    mov rsi, 1024*768*4     ; length (example)
    mov rdx, 3              ; PROT_READ|PROT_WRITE
    mov r10, 1              ; MAP_SHARED
    mov r8, [fbfd]
    xor r9, r9
    syscall
    mov [fbptr], rax

    ; Fill screen with blue
    mov rcx, 1024*768
    mov rdi, [fbptr]
    mov eax, 0x0000FF
.fill_loop:
    mov [rdi], eax
    add rdi, 4
    loop .fill_loop

    ; nanosleep(&req, NULL)
    mov rax, 35             ; sys_nanosleep
    mov rdi, ts_sec         ; pointer to timespec
    xor rsi, rsi            ; NULL
    syscall

    ; exit(0)
    mov rax, 60
    xor rdi, rdi
    syscall
