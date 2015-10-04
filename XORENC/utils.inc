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
