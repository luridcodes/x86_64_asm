%include "macros.asm"

section .data 
	SYS_WRITE 	equ 1 
	SYS_EXIT 	equ 60 
	STD_OUT 	equ 1
	EXIT_CODE	equ 0 

	NEW_LINE 	db 0xa 
	W_ARGS_MSG	db "Error: expected two CL args", 10 
	W_ARGS_MSG_L equ $-W_ARGS_MSG

section .text 
	global _start 

_start: 
	pop rcx 		; stores no args in stack to rxc 
	cmp rcx, 3		; check the number of args 
	je  processing 

argcError:			; if less than 2 params are passed  
	mov rax, SYS_WRITE 
	mov rdi, STD_OUT
	mov rsi, W_ARGS_MSG 
	mov rdx, W_ARGS_MSG_L
	syscall 
	jmp exit 

processing: 
	add rsp, 8
	pop rsi 		; store first arg in rsi 
	call str_to_int ; reads rsi in 8 bit segments to convert ACSII to int 
	mov r10, rax	; store result in r10  

	pop rsi 
	call str_to_int
	mov r11, rax 

	add r10, r11 	; stores sum in r10  
	mov rax, r10 
	xor rcx, rcx	; sets rxc to 0 as counter 

int_to_str: 
	mov rdx, 0 		; remove high part of dividend
					; basically limits the program to 64-bit results 
	mov rbx, 10 
	
	div rbx			; RAX/RBX, quotient stored in RAX and remainder in RDX 
	add rdx, 48 
	push rdx	; pushes 64 bits (size of register) to stack  
	inc rcx 
	cmp rax, 0x0
	jne int_to_str
	jmp print_result

print_result:
	mov rax, rcx
	mov rcx, 8 
	mul rcx			; string length * 8 = number of bytes  

	mov rdx, rax	; 3rd arg (length of string) for sys_write
	mov rax, SYS_WRITE
	mov rdi, STD_OUT
	mov rsi, rsp	; reads from the top of the stack (lowest address) upwards 
					; null bytes (0x00) are not printed on std_out 
	syscall 

    PRINT NEW_LINE, 1

exit: 
	mov rax, SYS_EXIT
	mov rdi, 0		; error code 0  
	syscall 

str_to_int: 
	xor rax, rax	; set the value of rax to 0  
	mov rcx, 10 	; base for multiplcation 

	__repeat:
		cmp [rsi], byte 0
					; compare value with null terminator 
					; if the string is finished (null), return
		je __return 
		mov bl, [rsi] 
					; only the first 8 bits of rsi is read 
		sub bl, 48	; the lower 8 bits of RBX  
		mul rcx		; RAX*RCX, stores 128 bit integer in RDX:RAX 
					; we ignore overflow in RDX
		movzx rbx, bl
		add rax, rbx; adds the result from RBX into the int
		inc rsi		; moves rsi to the next 8 bits to intepret next ACSII
		jmp __repeat 

	__return:  
		ret 
 
