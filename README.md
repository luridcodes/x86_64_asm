# X86_64 ASM Tutorial :D

	*** UNDER PRODUCTION: THIS TUTORIAL IS VERY MUCH INCOMPLETE *** 
## Introduction
This is a public repo containing tutorials on how to write ASM for x86_64 processors, including interacting with the kernel through syscalls, as well as fundamental data structures and algorithms in ASM. 

Through this tutorial, you will learn: 
- How to write and compile ASM code
- How registers work on CPU cache 
- How CPU instructions are passed in a program 
- How syscalls are used to interact with the kernel 
- How to write functions using stack frames 
- Basic command flow and loops 
- How memory works at a low level (stack and heap) 
- How to allocate runtime memory (brk and mmap) 
- How to make your computer do math faster (FPU vs AVX) 
And much more that is planned! 

In addition, this tutorial implements the following data structures and algorithms in pure ASM with **no C libraries**  (*this is a live table updated whenever a new DSA is implemented*)

| Data Structures | Algorithms |
|--|--|
|  linked list (stack and queue)       |                     |
|  queue (circular bufffer) || 

## How to use this tutorial 
Begin the tutorial using the blog posts located in the tutorial directory, which will walk you through basic ASM concepts. Each blog post covers a specific topic: 
1. Hello World in ASM (instructions, registers and syscalls) 
2. Basic memory concepts (stack, heap) 
3. Functions (loops, stack frame) 
4. I/O (files, CLI arguments, read and write syscalls) 
5. Arithmtic (FPU, AVX) 
6. Dynamic memory (brk and mmap) 

The rest of the repo is separated into 3 segments: 

|Segment|Description  |
|--|--|
| Projects | Contains tutorials on how to write programs in ASM, focussing primarily on using syscalls and software architecture in ASM compared to other languages (e.g. macros, preprocessor, segments, debugging) | 
Data Structures | Contains implementations of fundamental data structures in ASM -- instrumental in understanding how higher-level languages allocate memory and work with memory buffers to store data | 
|Algorithms |  Contains implementations of simple algorithms  
 
I have much to thank from [this tutorial](https://github.com/0xAX/asm/tree/master)  for instructing on the basics of ASM: I recommend that you read through that tutorial before this one, although I will also aim to cover most of the basics 

## Projects 
Start with OTP_encoder, which leverages sycalls, argv[], and looping functions to encode a file using the One Time Pad protocol. 

*Planned Projects:* 
- TCP server 
- Graphics library 
- Malloc 

## Running ASM 
I use [NASM](https://www.nasm.us/) on Linux to compile my ASM code -- it is optimal that you use Linux or WSL due to easier interaction with syscalls on Linux than windows. 
All code is run with 

    nasm -f elf64 -gdwarf file.asm 
And linked using GNU linker 

	ld -o a.out file.o 

If you use VIM, I prefer to run vanilla VIM without plugins, and a simple keymap you can place in your .vimrc to compile from within vim is: 

	autocmd FileType asm nnoremap <F1> :w<CR>:!clear && nasm -f elf64 -gdwarf % && ld -o %:r_exe %:r.o && rm %:r.o      

And you can map another key to run the executable:  

    autocmd FileType asm nnoremap <F2> :!clear && ./%:r_exe 
