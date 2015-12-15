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

  console_mode_message db 'Enter your text: $'

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

  text_length equ 255
  text db text_length dup('$')

data_segment ends

code_segment segment para public 'code'

include ..\COMMON\utils.inc
include ..\COMMON\stdlib.inc
include ..\COMMON\comarg.inc

print_help proc
    print help_message
    exit 0
    ret
print_help endp

console_mode proc
    print console_mode_message
    prepare_buffer text, text_length
    stdin_buffer_read text
    call process_text
    ret
console_mode endp

file_mode proc
    ret
file_mode endp

process_parameters proc
    param_exec buffer, buffer_length, 'h', print_help
    param_exec buffer, buffer_length, 'c', console_mode
    param_exec buffer, buffer_length, 'i', file_mode
    ret
process_parameters endp

process_text proc

    ret
process_text endp

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

  parameter_loop:
    call next_parameter_offset
    cmp bx, -2
    je exit_and_print_help
    cmp bx, -1
    je exit_prog

    paramcpy buffer, buffer_length
    call process_parameters
    memset buffer, buffer_length, '$'

    jmp parameter_loop

  exit_and_print_help:
    print help_message
  exit_prog:
    exit 0

code_segment ends
end start
