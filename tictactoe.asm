; Tic Tac Toe game in x86 assembly for Linux
; Assemble with: nasm -f elf tictactoe.asm
; Link with: ld -m elf_i386 tictactoe.o -o tictactoe

section .data
    board       db '1', '2', '3', '4', '5', '6', '7', '8', '9', 0    ; Game board with position numbers
    player      db 'X'                                                ; Current player (X or O)
    newline     db 10, 0                                              ; Newline character
    prompt      db "Player ", 0
    turn_msg    db "'s turn. Choose position (1-9): ", 0
    invalid_msg db "Invalid move! Try again.", 10, 0
    win_msg     db " wins!", 10, 0
    draw_msg    db "It's a draw!", 10, 0
    
    ; Board display templates
    space       db " ", 0
    pipe        db " | ", 0
    row_end     db " ", 10, 0
    horiz_line  db "---+---+---", 10, 0
    
    ; Buffer to hold individual characters for display
    char_buf    db " ", 0

section .bss
    input resb 2    ; User input buffer

section .text
    global _start

_start:
    call show_board     ; Display the initial board
    
game_loop:
    ; Display whose turn it is
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, prompt
    mov edx, 7          ; length of prompt
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, player
    mov edx, 1          ; length of player
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, turn_msg
    mov edx, 32         ; length of turn message
    int 80h
    
    ; Get player input
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, input
    mov edx, 2          ; read up to 2 bytes (digit + newline)
    int 80h
    
    ; Convert input to integer and check validity
    mov al, [input]
    sub al, '0'         ; Convert ASCII to integer
    
    ; Check if input is valid (1-9)
    cmp al, 1
    jl invalid_move
    cmp al, 9
    jg invalid_move
    
    ; Check if position is already taken
    dec al              ; Convert to 0-8 for array indexing
    movzx ebx, al
    mov cl, [board + ebx]
    cmp cl, 'X'
    je invalid_move
    cmp cl, 'O'
    je invalid_move
    
    ; Place the mark on the board
    mov cl, [player]
    mov [board + ebx], cl
    
    ; Update board and check for win
    call show_board
    call check_win
    cmp eax, 1          ; If eax=1, someone won
    je game_over
    
    ; Check for draw
    call check_draw
    cmp eax, 1          ; If eax=1, it's a draw
    je draw_game
    
    ; Switch player
    mov al, [player]
    cmp al, 'X'
    je set_player_o
    mov byte [player], 'X'
    jmp game_loop
    
set_player_o:
    mov byte [player], 'O'
    jmp game_loop
    
invalid_move:
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, invalid_msg
    mov edx, 26         ; length of invalid message
    int 80h
    jmp game_loop
    
game_over:
    ; Display winner message
    mov eax, 4
    mov ebx, 1
    mov ecx, player
    mov edx, 1
    int 80h
    
    mov eax, 4
    mov ebx, 1
    mov ecx, win_msg
    mov edx, 7
    int 80h
    
    jmp exit
    
draw_game:
    mov eax, 4
    mov ebx, 1
    mov ecx, draw_msg
    mov edx, 13
    int 80h
    
exit:
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; exit code 0
    int 80h
    
; Function to display the board in a proper 3x3 format
show_board:
    push eax
    push ebx
    push ecx
    push edx
    
    ; Print initial space
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h
    
    ; First row: display " 1 | 2 | 3 "
    ; First cell
    mov al, [board + 0]
    mov [char_buf], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 80h
    
    ; Separator
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe
    mov edx, 3
    int 80h
    
    ; Second cell
    mov al, [board + 1]
    mov [char_buf], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 80h
    
    ; Separator
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe
    mov edx, 3
    int 80h
    
    ; Third cell
    mov al, [board + 2]
    mov [char_buf], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 80h
    
    ; End of row
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Horizontal line
    mov eax, 4
    mov ebx, 1
    mov ecx, horiz_line
    mov edx, 12
    int 80h
    
    ; Print initial space for second row
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h
    
    ; Second row: display " 4 | 5 | 6 "
    ; First cell
    mov al, [board + 3]
    mov [char_buf], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 80h
    
    ; Separator
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe
    mov edx, 3
    int 80h
    
    ; Second cell
    mov al, [board + 4]
    mov [char_buf], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 80h
    
    ; Separator
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe
    mov edx, 3
    int 80h
    
    ; Third cell
    mov al, [board + 5]
    mov [char_buf], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 80h
    
    ; End of row
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Horizontal line
    mov eax, 4
    mov ebx, 1
    mov ecx, horiz_line
    mov edx, 12
    int 80h
    
    ; Print initial space for third row
    mov eax, 4
    mov ebx, 1
    mov ecx, space
    mov edx, 1
    int 80h
    
    ; Third row: display " 7 | 8 | 9 "
    ; First cell
    mov al, [board + 6]
    mov [char_buf], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 80h
    
    ; Separator
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe
    mov edx, 3
    int 80h
    
    ; Second cell
    mov al, [board + 7]
    mov [char_buf], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 80h
    
    ; Separator
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe
    mov edx, 3
    int 80h
    
    ; Third cell
    mov al, [board + 8]
    mov [char_buf], al
    mov eax, 4
    mov ebx, 1
    mov ecx, char_buf
    mov edx, 1
    int 80h
    
    ; End of row
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    ; Add a newline for spacing
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 80h
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
    
; Check if a player has won
check_win:
    ; For simplicity, we'll just check a few win conditions
    ; Row 1
    mov al, [board + 0]
    cmp al, [board + 1]
    jne check_row2
    cmp al, [board + 2]
    jne check_row2
    mov eax, 1          ; Win found
    ret
    
check_row2:
    ; Row 2
    mov al, [board + 3]
    cmp al, [board + 4]
    jne check_row3
    cmp al, [board + 5]
    jne check_row3
    mov eax, 1          ; Win found
    ret
    
check_row3:
    ; Row 3
    mov al, [board + 6]
    cmp al, [board + 7]
    jne check_col1
    cmp al, [board + 8]
    jne check_col1
    mov eax, 1          ; Win found
    ret
    
check_col1:
    ; Column 1
    mov al, [board + 0]
    cmp al, [board + 3]
    jne check_col2
    cmp al, [board + 6]
    jne check_col2
    mov eax, 1          ; Win found
    ret
    
check_col2:
    ; Column 2
    mov al, [board + 1]
    cmp al, [board + 4]
    jne check_col3
    cmp al, [board + 7]
    jne check_col3
    mov eax, 1          ; Win found
    ret
    
check_col3:
    ; Column 3
    mov al, [board + 2]
    cmp al, [board + 5]
    jne check_diag1
    cmp al, [board + 8]
    jne check_diag1
    mov eax, 1          ; Win found
    ret
    
check_diag1:
    ; Diagonal 1
    mov al, [board + 0]
    cmp al, [board + 4]
    jne check_diag2
    cmp al, [board + 8]
    jne check_diag2
    mov eax, 1          ; Win found
    ret
    
check_diag2:
    ; Diagonal 2
    mov al, [board + 2]
    cmp al, [board + 4]
    jne no_win
    cmp al, [board + 6]
    jne no_win
    mov eax, 1          ; Win found
    ret
    
no_win:
    xor eax, eax        ; No win found
    ret
    
; Check if the game is a draw
check_draw:
    push ebx
    push ecx
    
    mov ecx, 9          ; Loop counter for 9 positions
    xor ebx, ebx        ; Start at board[0]
    
check_draw_loop:
    mov al, [board + ebx]
    cmp al, 'X'
    je position_taken
    cmp al, 'O'
    je position_taken
    
    ; Found an open position, not a draw
    xor eax, eax
    pop ecx
    pop ebx
    ret
    
position_taken:
    inc ebx
    loop check_draw_loop
    
    ; If we've checked all positions and they're all taken, it's a draw
    mov eax, 1
    pop ecx
    pop ebx
    ret