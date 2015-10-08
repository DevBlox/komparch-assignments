; returns the next whitespace separated program parameter
; in a separate buffer for it
get_next_parameter proc
    current_loc dw 0 ; persistent offset counter
    ret
get_next_parameter endp

; prints a stirng to console
print macro string
    mov ah, 09h
    lea dx, string
    int 21h
endm ; print

; prints a string that is already loaded to dx
print_dx macro
    mov ah, 09h
    int 21h
endm ; print_dx

; exits program with return code
exit macro exit_code
    mov ah, 4Ch
    mov al, exit_code
    int 21h
endm ; exit

; loads segment to ds register
load_data_segment macro segment
    mov ax, segment
    mov ds, ax
endm ; load_data_segment

; fills a buffer with data
stdin_buffer_read macro buffer
    mov ah, 0Ah
    lea dx, buffer
    int 21h
endm ; stdin_buffer_read

stdin_prepare_buffer macro buffer, size
    mov [buffer], size
    mov [buffer + 01h], 0
endm ; stdin_prepare_buffer
