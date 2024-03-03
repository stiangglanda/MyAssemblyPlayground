section .bss           ;Uninitialized data
   num resb 5
   numlen equ $ - num  ;length of the string

section	.text
   global _start     ;must be declared for linker (ld)
	
_start:	            ;tells linker entry point
   call printMenu
   call readInput
   call printInput
	
   mov	eax,1       ;system call number (sys_exit)
   int	0x80        ;call kernel

printMenu:
   mov	edx,msglen     ;message length
   mov	ecx,msg     ;message to write
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel

   mov	edx,fieldlen     ;message length
   mov	ecx,field     ;message to write
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel
   ret

readInput:
   mov	edx,numlen  ;inputbuffer length
   mov	ecx,num     ;input buffer
   mov	ebx,2       ;file descriptor (stdin)
   mov	eax,3       ;system call number (sys_read)
   int	0x80        ;call kernel
   ret

printInput:
   mov	edx,numlen  ;message length
   mov	ecx,num     ;message to write
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel
   ret

section	.data
msg db 'Tic Tac Toe', 0xa  ;string to be printed
msglen equ $ - msg     ;length of the string

field db '+-+-+-+', 0xa, '| | | |', 0xa, '+-+-+-+', 0xa, '| | | |', 0xa, '+-+-+-+', 0xa, '| | | |', 0xa, '+-+-+-+', 0xa  ;string to be printed
fieldlen equ $ - field     ;length of the string