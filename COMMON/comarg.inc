; returns the next whitespace separated program parameter
; in a separate buffer for it
next_parameter_offset proc
        locals @@
        xor cx, cx
        mov cl, es:[80h]
        mov bx, last_parameter

    @@chk_loop:
        cmp bx, cx
        je @@exit_no_res
        cmp byte ptr es:81h[bx], ' '
        je @@exit
        inc bx
        jmp @@chk_loop

    @@exit_no_res:
        mov bx, -2
    @@exit:
        inc bx
        mov last_parameter, bx
        ret

        last_parameter dw 0 ; persistent offset counter
next_parameter_offset endp

; Copies parameter to buffer on ds
; This macro expects bx to have an offset of the parameter
paramcpy macro buf, buf_size
        lea di, buf
        mov dx, buf_size
        call paramcpy_proc
endm

paramcpy_proc proc
        xor cx, cx
        mov cl, es:[80h]

        ret
endp
