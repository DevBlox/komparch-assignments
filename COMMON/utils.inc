; counts character count in string, excludes carrage return
; Parameters:
; si -> buffer effective address
; cx -> buffer size
; Result:
; bx -> string length
string_length_proc proc
        mov bx, 0 ; bx is used as offset
        mov al, 0Dh ; carrage return
        jmp @@start

    @@count:
        inc bx
    @@start:
        cmp bx, cx
        je @@end
        mov ah, si[bx]
        cmp al, ah
        jne @@count

    @@end:
        ret
string_length_proc endp

; macro for calling string_length_proc
buflen macro buffer, result
    lea si, buffer
    xor cx, cx
    mov cl, [si]
    add si, 02h
    call string_length_proc
    mov [result], bx
endm ; strlen

; prints a stirng to console
print macro string
        mov ah, 09h
        lea dx, string
        int 21h
endm ; print

; prints a dos buffer to console
buffer_print macro string
        mov ah, 09h
        lea dx, string
        add dx, 02h
        int 21h
endm ; buffer_print

; prints a string that is already loaded to dx
print_dx macro
        mov ah, 09h
        int 21h
endm ; print_dx

; fills a buffer with data
stdin_buffer_read macro buffer
        mov ah, 0Ah
        lea dx, buffer
        int 21h
endm ; stdin_buffer_read

; initiates the first bytes of the dos bufffer type
prepare_buffer macro buffer, size
    mov [buffer], size
    mov [buffer + 01h], 0
endm ; prepare_buffer

terminate_string macro buffer, length
    mov bx, length
    lea si, buffer
    mov byte ptr si[bx], 0Ah
    inc bx
    mov byte ptr si[bx], 0Dh
    inc bx
    mov byte ptr si[bx], '$'
endm ; terminate_string

; adds endline characters to the end of a buffer
terminate_buffer macro buffer, length
    mov bx, length
    lea si, buffer
    add si, 02h
    mov byte ptr si[bx], 0Ah
    inc bx
    mov byte ptr si[bx], 0Dh
    inc bx
    mov byte ptr si[bx], '$'
endm ; terminate_buffer

load_buffer macro register, buffer
    lea register, buffer
    add register, 02h
endm ; load_buffer

; prints character to stdout
print_char macro char
    mov dl, char
    mov ah, 02h
    int 21h
endm
