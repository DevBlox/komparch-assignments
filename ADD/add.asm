.model small
assume ss:stack_segment, ds:data_segment, cs:code_segment

stack_segment segment para stack 'stack'
	db 100h dup(0)
stack_segment ends

data_segment segment para public 'data'
	string db 'Hello world!', 10, 13, '$'
data_segment ends

code_segment segment para public 'code'
	locals @@

	start:
		mov ax, seg data_segment
		mov ds, ax

        ; setting numbers
        mov ax, 7
        mov bx, 1

    loop_label:
        mov dx, ax
        xor dx, bx
        mov cx, ax
        or  cx, bx
        shl cx, 1
        mov ax, dx
        mov bx, cx
        jcxz loop_label

        add ax, 48
        mov ah, 02h
        int 21h

        mov ah, 4Ch
        mov al, 00h
        int 21h

code_segment ends
end start
