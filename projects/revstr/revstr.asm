format ELF64 executable 
entry _start

segment readable writeable
	SYS_WRITE 	equ 1
	SYS_EXIT	equ 60 
	STD_OUT 	equ 1

	NEW_LINE 	db 0xa

	INPUT 		db "the quick brown fox jumps over the lazy do", 10  
	INPUT_LEN	= $ - INPUT 

	OUTPUT 		rb INPUT_LEN	; reserves memory the size of INPUT_LEN


segment readable executable 

_start:
	xor rcx, rcx				; reset rcx  
	mov rsi, INPUT 
	mov rdi, OUTPUT 
	jmp reverseStringAndPrint
	jmp _exit

_exit:
	mov rax, SYS_EXIT 
	mov rdi, 67 
	syscall 

; *************************************
; *          REVERSE STRING           *

; *************************************

; loads string byte by byte into the stack, and counts the number of bytes 
; in the string before calling `reverseString` when end of string is reached 
reverseStringAndPrint: 	
	cmp byte [rsi], 0 		; checks if end of string reached (null terminator)
	mov rdx, rcx			; copies length of string to rdx (for use later) 
	je reverseString

	lodsb					; load one byte from RSI, stored to AL   
	push rax 				; 
	inc rcx 
	jmp reverseStringAndPrint

	reverseString: 
		cmp rcx, 0 
		je  printResult 
		pop rax 
		mov [rdi], rax 
		inc rdi				; moves pointer to the next byte (char) in OUTPUT 
		dec rcx 
		jmp reverseString

	printResult: 
		mov rax, SYS_WRITE 
		mov rdi, STD_OUT 
		mov rsi, OUTPUT 
							; input_len = output_len, no need to mov rdx
		syscall 
	
	jmp _exit

