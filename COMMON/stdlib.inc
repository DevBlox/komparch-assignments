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

memset macro buf, buf_size, value
        lea si, buf
        mov cx, buf_size
        mov al, value
        call memset_proc
endm

memset_proc proc
        xor bx, bx
    @@set_loop:
        mov si[bx], al
        inc bx
        loop @@set_loop

        ret
memset_proc endp

fopen macro open_mode, filename
    mov al, open_mode
    mov ah, 3Dh
    lea dx, filename
    int 21h
endm

fclose macro handle
    mov ah, 3Eh
    mov bx, handle
    int 21h
endm

fread macro handle, buffer, buffer_size
    mov ah, 3Fh
    mov bx, handle
    mov cx, buffer_size
    lea dx, buffer
    int 21h
endm
