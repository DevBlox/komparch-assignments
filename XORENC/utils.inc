; returns the next whitespace separated program parameter
; in a separate buffer for it
get_next_parameter proc
    ; persistent offset counter
    current_loc dw 0

    ret
get_next_parameter endp

; prints the stirng to console
print macro string_pointer
    mov ah, 09h
    lea dx, string_pointer
    int 21h
print endp

; exits program with return code
exit macro exit_code
    mov ah, 4Ch
    mov al, exit_code
    int 21h
exit endm

; loads segment to ds register
load_segment macro segment
    mov ax, segment
    mov ds, ax
    ret
load_segment endm
