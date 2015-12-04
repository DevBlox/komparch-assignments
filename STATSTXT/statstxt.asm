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
               db '-c    ->   console mode (default)', 10, 13, '$'

  letter_a_desc db 'Amount of letters a$'
  letter_b_desc db 'Amount of letters b$'
  endline db 10, 13, '$'

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
  buffer db buffer_length dup('$')

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

  test_loop:
    call next_parameter_offset
    cmp bx, -1
    je exit_prog
    paramcpy buffer, buffer_length
    print buffer
    print endline
    memset buffer, buffer_length, '$'
    jmp test_loop

  exit_prog:
    exit 0

code_segment ends
end start
