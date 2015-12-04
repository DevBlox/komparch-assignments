%title 'Text statistics counting program'

model small

assume ss:stack_segment, ds:data_segment, cs:code_segment

stack_segment segment para stack 'stack'
  db 100h dup(0)
stack_segment ends

data_segment segment para public 'data'
  help_message db 'STATSTXT - Text statistics counting program', 10, 13
               db 'Usage: STATSTXT.EXE <parameter> <parameter_value>', 10 ,13
               db 'Parameters:', 10, 13
               db '-i    ->   input text file', 10, 13
               db '-h    ->   print this help', 10, 13
               db '-c    ->   console mode (default)', 10, 13, 10, 13, '$'

  letter_a_desc db 'Amount of letters a$'
  letter_b_desc db 'Amount of letters b$'

  filter struc
    func dw 0
    value dw 0
    desc dw 0
  ends

  label filters filter
    filter <letter_a_func, 0, letter_a_desc>
    filter <letter_b_func, 0, letter_b_desc>

  number_filters dw 2

  buffer_length equ 256
  buffer db buffer_length

data_segment ends

code_segment segment para public 'code'

include ..\COMMON\utils.inc
include ..\COMMON\stdlib.inc
include ..\COMMON\comarg.inc

; ============================
; filters begin
; ============================
  letter_b_func proc

    ret
  letter_b_func endp

  letter_a_func proc


    ret
  letter_a_func endp
; ============================
; filters end
; ============================

  start:
    load_data_segment data_segment
    print help_message

test_loop:
    call next_parameter_offset
    lea dx, es:[81h + bx]
    print_dx
    cmp bx, -1
    jne test_loop

    exit 0

code_segment ends
end start
