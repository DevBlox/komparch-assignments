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
