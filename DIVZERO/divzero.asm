%title 'Iterrupt of division by zero'

model small

assume ss:stack_segment, ds:data_segment, cs:code_segment

stack_segment segment para stack 'stack'
  db 100h dup(0)
stack_segment ends

data_segment segment para public 'data'

    success_message db 'Division by zero!', 10, 13, '$'
    endline db 10, 13, '$'

    m_ax db 'AX = $'
    m_bx db 'BX = $'
    m_cx db 'CX = $'
    m_dx db 'DX = $'
    m_ip db 'IP = $'

    interrupt struc
        segement dw 0
        routine dw 0
    ends

    label div_zero interrupt
      interrupt <code_segment, division_by_zero>

data_segment ends

code_segment segment para public 'code'

    include ..\COMMON\utils.inc
    include ..\COMMON\stdlib.inc
    include ..\COMMON\comarg.inc

    division_by_zero proc
        push dx
        push cx
        push bx
        push ax

        print success_message

        print m_ax
        pop ax
        print_hex ax
        print endline

        print m_bx
        pop bx
        print_hex bx
        print endline

        print m_cx
        pop cx
        print_hex cx
        print endline

        print m_dx
        pop dx
        print_hex dx
        print endline

        exit 0
        iret
    division_by_zero endp

    load_interrupt_routine proc
        xor ax, ax
        mov es, ax

        lea si, div_zero
        mov bx, 0000h

        mov ax, [si].routine
        mov es:[bx], ax
        add bx, 2
        mov ax, [si].segement
        mov es:[bx], ax

        ret
    load_interrupt_routine endp

  start:
    load_data_segment data_segment
    call load_interrupt_routine

    mov ax, 66
    mov cx, 0
    mov dx, 1534h
    div cx

    exit 0

code_segment ends
end start
