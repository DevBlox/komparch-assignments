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

; Parameter copy procedure
; bx -> offset in parameter buffer
; di -> buffer to copy to
; dx -> buffer size
paramcpy_proc proc
        locals @@
        xor cx, cx
        mov ah, es:[80h]
        sub ah, bl

    @@copy_loop:
        mov al, es:[81h + bx]
        cmp al, ' '
        je @@exit
        push bx
        mov bx, cx
        mov ds:[di + bx], al
        pop bx
        inc cl
        inc bx
        cmp cl, ah
        jne @@copy_loop

    @@exit:
        ret
endp

; Checks if paraeter exists and launches a procedure
param_exec macro buf, buf_size, property_identifier, procedure
        lea si, buf
        mov cx, buf_size
        mov dl, property_identifier
        mov bx, procedure
        call param_exec_proc
endm

; Parameter checking and executing procedure
; si -> buffer with parameter
; cx -> buffer size
; sl -> property identifier
; bx -> procedure address
param_exec_proc proc
      locals @@
      cmp byte ptr [si], '-'
      jne @@exit

      cmp [si + 1], al
      jne @@exit
      call [bx]

    @@exit:
      ret
param_exec_proc endp
