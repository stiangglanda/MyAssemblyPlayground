section .bss
    num resb 5         ; Allocate 1 byte for num
    numlen equ $ - num ; Length of the string

section .text
    global _start

_start:
loop1:
   call readInput
   call makeXMove
   call printBoard

   call checkWin

   call readInput
   call makeOMove
   call printBoard

   call checkWin
   jmp loop1

   call exit

printBoard:    ; Print the x array
   mov edx, 3             ; Number of bytes to write
   mov ecx, board             ; Message to write
   mov ebx, 1             ; File descriptor (stdout)
   mov eax, 4             ; System call number (sys_write)
   int 0x80               ; Call kernel

   mov edx, 1             ; Number of bytes to write
   mov ecx, newLine       ; Message to write
   mov ebx, 1             ; File descriptor (stdout)
   mov eax, 4             ; System call number (sys_write)
   int 0x80               ; Call kernel

   mov edx, 3             ; Number of bytes to write
   mov ecx, board             ; Message to write
   add ecx, 3
   mov ebx, 1             ; File descriptor (stdout)
   mov eax, 4             ; System call number (sys_write)
   int 0x80               ; Call kernel

   mov edx, 1             ; Number of bytes to write
   mov ecx, newLine       ; Message to write
   mov ebx, 1             ; File descriptor (stdout)
   mov eax, 4             ; System call number (sys_write)
   int 0x80               ; Call kernel

   mov edx, 3             ; Number of bytes to write
   mov ecx, board             ; Message to write
   add ecx, 6
   mov ebx, 1             ; File descriptor (stdout)
   mov eax, 4             ; System call number (sys_write)
   int 0x80               ; Call kernel

   mov edx, 1             ; Number of bytes to write
   mov ecx, newLine       ; Message to write
   mov ebx, 1             ; File descriptor (stdout)
   mov eax, 4             ; System call number (sys_write)
   int 0x80               ; Call kernel
   ret

readInput:
   mov edx, numlen        ; Input buffer length
   mov ecx, num           ; Input buffer
   mov ebx, 0             ; File descriptor (stdin)
   mov eax, 3             ; System call number (sys_read)
   int 0x80               ; Call kernel
   ret

makeXMove:
   movzx ebx, byte [num]  ; Load the ASCII character into ebx
   sub ebx, '0'           ; Convert ASCII character to integer value
   sub ebx, 1
   ; Check if the input is within the range of the array
   cmp ebx, 0             ; Check if ebx is less than 0
   jl exit                ; If less than 0, exit the program
   cmp ebx, 9             ; Check if ebx is greater than 2
   jg exit                ; If greater than 2, exit the program

   mov eax, board             ; Load the address of x into eax
   add eax, ebx           ; Calculate the address of the element to update
   mov byte [eax], 'X'    ; Update the element to 'X'
   ret

makeOMove:
   movzx ebx, byte [num]  ; Load the ASCII character into ebx
   sub ebx, '0'           ; Convert ASCII character to integer value
   sub ebx, 1
   ; Check if the input is within the range of the array
   cmp ebx, 0             ; Check if ebx is less than 0
   jl exit                ; If less than 0, exit the program
   cmp ebx, 9             ; Check if ebx is greater than 2
   jg exit                ; If greater than 2, exit the program

   mov eax, board             ; Load the address of x into eax
   add eax, ebx           ; Calculate the address of the element to update
   mov byte [eax], 'O'    ; Update the element to 'X'
   ret

checkWin:
    ; Check rows for 'X'
    mov ecx, 0          ; Initialize row counter
    mov eax, 0          ; Initialize index counter
.checkXRow:
    cmp ecx, 3          ; Check if reached end of rows
    je .checkORow       ; If yes, switch to checking rows for 'O'
    cmp byte [board + eax], 'X'  ; Check current element for 'X'
    jne .checkORow      ; If not 'X', switch to checking rows for 'O'
    add eax, 1          ; Move to next element
    inc ecx             ; Increment row counter
    cmp ecx, 3          ; Check if all rows have been checked
    jne .checkXRow      ; If not, continue checking rows for 'X'
    jmp .XwinDetected    ; If reached here, player X wins

.checkORow:
    ; Check rows for 'O'
    mov ecx, 0          ; Initialize row counter
    mov eax, 0          ; Initialize index counter
.checkORowLoop:
    cmp ecx, 3          ; Check if reached end of rows
    je .checkColumns    ; If yes, switch to checking columns
    cmp byte [board + eax], 'O'  ; Check current element for 'O'
    jne .nextRow        ; If not 'O', move to next row
    add eax, 1          ; Move to next element
    inc ecx             ; Increment row counter
    cmp ecx, 3          ; Check if all rows have been checked
    jne .checkORowLoop  ; If not, continue checking rows for 'O'
    jmp .noWinDetected  ; If reached here, no win detected

.nextRow:
    add eax, 1          ; Move to next element
    inc ecx             ; Increment row counter
    cmp ecx, 3          ; Check if all rows have been checked
    jne .checkORowLoop  ; If not, continue checking rows for 'O'
    jmp .checkColumns   ; If reached here, switch to checking columns

.checkColumns:
    ; Check columns for 'X'
    mov ecx, 0          ; Initialize column counter
    mov eax, 0          ; Initialize index counter
.checkXColumn:
    cmp ecx, 3          ; Check if reached end of columns
    je .checkOColumn    ; If yes, switch to checking columns for 'O'
    cmp byte [board + eax], 'X'  ; Check current element for 'X'
    jne .checkOColumn   ; If not 'X', switch to checking columns for 'O'
    add eax, 3          ; Move to next element in column
    inc ecx             ; Increment column counter
    cmp ecx, 3          ; Check if all columns have been checked
    jne .checkXColumn   ; If not, continue checking columns for 'X'
    jmp .XwinDetected    ; If reached here, player X wins

.checkOColumn:
    ; Check columns for 'O'
    mov ecx, 0          ; Initialize column counter
    mov eax, 0          ; Initialize index counter
.checkOColumnLoop:
    cmp ecx, 3          ; Check if reached end of columns
    je .checkDiagonals  ; If yes, switch to checking diagonals
    cmp byte [board + eax], 'O'  ; Check current element for 'O'
    jne .nextColumn     ; If not 'O', move to next column
    add eax, 3          ; Move to next element in column
    inc ecx             ; Increment column counter
    cmp ecx, 3          ; Check if all columns have been checked
    jne .checkOColumnLoop  ; If not, continue checking columns for 'O'
    jmp .noWinDetected  ; If reached here, no win detected

.nextColumn:
    add eax, 3          ; Move to next element in column
    inc ecx             ; Increment column counter
    cmp ecx, 3          ; Check if all columns have been checked
    jne .checkOColumnLoop  ; If not, continue checking columns for 'O'
    jmp .checkDiagonals ; If reached here, switch to checking diagonals

.checkDiagonals:
    ; Check diagonals for 'X'
    cmp byte [board], 'X'  ; Check top-left to bottom-right diagonal for 'X'
    je .checkXDiagonal
    cmp byte [board + 2], 'X'  ; Check top-right to bottom-left diagonal for 'X'
    je .XwinDetected     ; If reached here, player X wins

.checkXDiagonal:
    mov ecx, 0          ; Initialize index counter for diagonal
    mov eax, 0
.checkXDiagonalLoop:
    cmp ecx, 3          ; Check if reached end of diagonal
    je .noWinDetected   ; If yes, no win in this diagonal
    cmp byte [board + eax], 'X'  ; Check current element for 'X'
    jne .noWinDetected  ; If not 'X', no win in this diagonal
    add eax, 4          ; Move to next element in diagonal
    inc ecx             ; Increment index counter for diagonal
    jmp .checkXDiagonalLoop  ; Continue checking diagonal

.noWinDetected:
   mov	edx,noWinMsglen     ;message length
   mov	ecx,noWinMsg     ;message to write
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel
   mov eax, 0          ; Set return value to 0 (no win)
   ret

.XwinDetected:
   mov	edx,XwinMsglen     ;message length
   mov	ecx,XwinMsg     ;message to write
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel
   mov eax, 1          ; Set return value to 1 (win)
   ret

.OwinDetected:
   mov	edx,OwinMsglen     ;message length
   mov	ecx,OwinMsg     ;message to write
   mov	ebx,1       ;file descriptor (stdout)
   mov	eax,4       ;system call number (sys_write)
   int	0x80        ;call kernel
   mov eax, 1          ; Set return value to 1 (win)
   ret

exit:    ; Exit the program
   mov eax, 1             ; System call number (sys_exit)
   xor ebx, ebx           ; Exit status 0
   int 0x80               ; Call kernel

section .data
board:
   db '1', '2', '3', '4', '5', '6', '7', '8', '9'
boardlen equ $ - board ; Length of the string
newLine db 0xA
msg db 'Hello, world!', 0xa  ;string to be printed
len equ $ - msg     ;length of the string
XwinMsg db 'X Win detected!', 0xA  ; Message for win detected
XwinMsglen equ $ - XwinMsg     ;length of the string
OwinMsg db 'O Win detected!', 0xA  ; Message for win detected
OwinMsglen equ $ - OwinMsg     ;length of the string
noWinMsg db 'No win detected.', 0xA  ; Message for no win detected
noWinMsglen equ $ - noWinMsg     ;length of the string
