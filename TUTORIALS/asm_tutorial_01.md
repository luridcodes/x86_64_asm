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

The code, however intimidating, can be broken down into a few parts. 
As we are using NASM, we need to declare different sections, to tell the compiler which part of the code does which function. 
There are 3 basic sections, including `.data`, which is used to declare static variables (which do not change over time). 
Above, this is declared through the `db` pseudo-instruction, which reserved bytes (8 bits in a x86 system). 
You may notice, however, that the string itself is constituted by multiple bytes (each character being one byte). 
Thus, `db` can also be used to store a sequence of bytes, similar to an array. 
Secondly, the `$` symbol in line 3 is an indication of the current stack pointer (the current 'last' address in memory). 
We use this to calculate the length of `msg`, which is used by deducting the start address of `msg`, stored in `msg`, from the stack pointer, therefore returning all the space used by the string "Hello World" itself. 

Next, the `.text` section is used for the code itself, which is the instructions passed to the CPU when running the program. `global _start` instructs the compiler that the program begins at the `_start` segment, which is declared using `_start:`. Multiple sections can be declared, which act as ways for you to organise your code. 

Next, the code itself. Unlike higher-level languages like C, there are no 'functions' pre-defined for us besides CPU instructions. 
Thus, in order to print something to the terminal, we have to interact with the linux kernel by calling the OS. 
We do this through syscalls, or system calls. 
A full list of linux syscalls can be found [here](https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/). 
To make a syscall, we have to pass instructions to the CPU. 
These are often listed in the man pages in C syntax, so it would be good if you familiarised yourself with those. 
For the `write` syscall, the function is shown in the `man` page as: 

| NR    | syscall name | %rax | arg0 (%rdi)     | arg1 (%rsi)     | arg2 (%rdx)  |
| :---: | :---         | :--- | :---            | :---            | :---         |
| 1     | write        | 0x01 | unsigned int fd | const char *buf | size_t count |

This table shows us all we need to know to print something to the terminal. Each column represents some argument we can pass to the CPU, and the headers show in which register each argument should be placed before making the syscall. 
For example, in order to tell the CPU we want to syscall `write`, we should pass `0x01` (equivalent of 1 in base 10) to `%rax`, which is 64 bits on a 64-bit system. 
To pass an argument, we use the `mov` instruction, which tells the CPU to move the value of 0x01 to the location pointed to by `rax`. 
Secondly, we should pass `unsigned int fd`, which is an unsigned integer describing the file which we want to write to. 
We pass 1 for standard output. Then we need to pass a pointer to the buffer in which our string is stored. 
Remember that we declared our string using `msg`. The memory value at `msg` cannot store the entire string - since it is only one byte. 
Instead, `msg` is a memory address which stores the location of the first byte of the string, therefore acting as a pointer for the string. 
Lastly, we need to pass to the CPU the number of bytes to read starting from the location `msg`. Basically, it is the length of the string. 
After we have set all the registers to their respective arguments, we make `syscall` to tell the linux kernel to carry out the function. We can interact with the kernel in this manner, and make use of all the syscalls which have been coded into the linux kernel for our convenience. 

After we do this, we need to exit the program safely, therefore we pass `60` to `rax`, which is the argument number for the `exit` syscall, and to `rdi` we pass an exit code (in this case 1 by default). After we make this syscall, the program will exit. 

A number of things you may have noticed is that we re-use registers for syscalls. This is important to keep in mind when coding in assembly.
Registers are memory locations which can be accessed by the CPU very fast, therefore act as a way to carry out rapid instructions. 
However, every time we make a syscall, registers may be affected. Therefore, as good practice, you should always ensure that the values of registers after syscalls are the same as the ones you think they are. A full list of registers can be found [here](https://math.hws.edu/eck/cs220/f22/registers.html). 

Congratulations! This is all you need to know to write a basic HelloWorld program. In our next tutorial, we will go through registers in detail - so don't worry if you don't yet understand what `%rax` stands for, or how the CPU parses instructions.  
