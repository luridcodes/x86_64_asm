# X86_64 ASM Tutorial :D

	*** UNDER PRODUCTION: THIS TUTORIAL IS VERY MUCH INCOMPLETE *** 
## Introduction
Hello! This is my first public repo containing tutorials on how to write ASM for x86_64 processors, including interacting with the kernel through syscalls, as well as fundamental data structures and algorithms in ASM. The repo is separated into two segments: 

I have much to thank from [this tutorial](https://github.com/0xAX/asm/tree/master)  for instructing on the basics of ASM: I recommend that you read through that tutorial before this one, although I will also aim to cover most of the basics 

|Segment|Description  |
|--|--|
| Projects | Contains tutorials on how to write programs in ASM, focussing primarily on using syscalls and software architecture in ASM compared to other languages (e.g. macros, preprocessor, segments, debugging) | 
Data Structures | Contains implementations of fundamental data structures in ASM -- instrumental in understanding how higher-level languages allocate memory and work with memory buffers to store data | 
|Algorithms |  Contains implementations of simple algorithms  
 
## Running ASM 
I use [NASM](https://www.nasm.us/) on Linux to compile my ASM code -- it is optimal that you use Linux or WSL due to easier interaction with syscalls on Linux than windows. 
All code is run with 

    nasm -f elf64 -gdwarf file.asm 
And linked using GNU linker 

	ld -o a.out file.o 

If you use VIM, I prefer to run vanilla VIM without plugins, and a simple keymap you can use to compile is: 

	autocmd FileType asm nnoremap <F1> :w<CR>:!clear && nasm -f elf64 -gdwarf % && ld -o %:r_exe %:r.o && rm %:r.o      

And you can map another key to run the executable 

	autocmd FileType asm nnoremap <F2> :!clear && ./%:r_exe 
  2 autocmd FileType asm nnoremap <F2> :!clear && ./%:r_exe 
 

