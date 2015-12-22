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
               db '-c    ->   console mode', 10, 13, '$'

  console_mode_message db 'Enter your text (up to 255 characters): $'
  missing_file_param_message db 'Filename argument is missing!$'
  open_file_failure db 'Failed to open file!$'
  endline db 10, 13, '$'

  ; ================== Filters ==================
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

  ; ================== Filters end ==================

  ; ================ buffers begin =================
  buffer_length equ 255
  buffer db buffer_length dup('$')

  text_buffer_length equ 255
  text_buffer db text_buffer_length dup('$')
  ; ================ buffers end =================

  ; ================ buffer io handler data begin ===============
  fill_buffer_proc_p dw 0
  fetch_byte_proc_p dw 0
  fetch_byte_offset dw 0
  file_handle dw 0 ; unused for console
  ; ================ buffer io handler data begin ===============

data_segment ends

code_segment segment para public 'code'

include ..\COMMON\utils.inc
include ..\COMMON\stdlib.inc
include ..\COMMON\comarg.inc

; ================ buffer io handler procedures begin ===============
read_byte proc
    locals @@

  @@start:
    mov cx, fetch_byte_offset
    cmp cx, text_buffer_length
    jge @@refill

    mov bx, fetch_byte_proc_p
    call bx
    jmp @@done

  @@refill:
    mov bx, fill_buffer_proc_p
    call bx
    cmp bx, -1
    je @@no_more_data
    jmp @@start

  @@no_more_data:
    mov al, -1
  @@done:
    ret
read_byte endp
; ================ buffer io handler procedures end =================
; ================ data source specific begin ===========================
console_fill proc
    mov bx, -1
    ret
console_fill endp

console_fetch_byte proc
    locals @@
    mov bx, fetch_byte_offset
    mov al, text_buffer[bx]
    cmp al, 0Dh
    je @@return_no_char
    inc fetch_byte_offset
    ret

  @@return_no_char:
    mov al, -1
    ret
console_fetch_byte endp

file_fill_buffer proc
    locals @@
    memset text_buffer, text_buffer_length, '$'
    fread file_handle, text_buffer, text_buffer_length
    mov bx, 0
    mov fetch_byte_offset, 0
    ret
file_fill_buffer endp

file_fetch_byte proc
    locals @@
    mov bx, fetch_byte_offset
    mov al, text_buffer[bx]
    cmp al, 0Ah
    je @@close_file
    inc fetch_byte_offset
    jmp @@done

  @@close_file:
    fclose file_handle
    mov al, -1
  @@done:
    ret
file_fetch_byte endp
; ================ data source specific end ===========================
; ==================== parameter processing begin ====================
print_help proc
    print help_message
    exit 0
    ret
print_help endp

console_mode proc
    print console_mode_message
    prepare_buffer text_buffer, text_buffer_length
    stdin_buffer_read text_buffer
    print endline

    mov fetch_byte_offset, 2

    lea bx, console_fetch_byte
    mov fetch_byte_proc_p, bx
    lea bx, console_fill
    mov fill_buffer_proc_p, bx
    ret
console_mode endp

file_mode proc
    locals @@
    memset buffer, buffer_length, 00h
    call next_parameter_offset
    cmp bx, -1
    jle @@no_param_error_print
    paramcpy buffer, buffer_length

    lea bx, file_fill_buffer
    mov fill_buffer_proc_p, bx

    lea bx, file_fetch_byte
    mov fetch_byte_proc_p, bx

    fopen 00h, buffer
    jc @@error_opening_file_print
    mov file_handle, ax
    call file_fill_buffer
    ret

  @@no_param_error_print:
    print missing_file_param_message
    exit -1

  @@error_opening_file_print:
    print open_file_failure
    exit -1
file_mode endp

process_parameters proc
    param_exec buffer, buffer_length, 'h', print_help
    param_exec buffer, buffer_length, 'c', console_mode
    param_exec buffer, buffer_length, 'i', file_mode
    ret
process_parameters endp

; ==================== parameter processing end ====================
; =================== filters procedures begin ===================
  letter_b_func proc

    ret
  letter_b_func endp

  letter_a_func proc

    ret
  letter_a_func endp
; =================== filters procedures end ===================

; =================== start of code execution ===================
  start:
    load_data_segment data_segment

  parameter_loop:
    call next_parameter_offset
    cmp bx, -2
    je exit_and_print_help
    cmp bx, -1
    je filter_stage

    paramcpy buffer, buffer_length
    call process_parameters
    memset buffer, buffer_length, '$'

    jmp parameter_loop

  filter_stage:
    call read_byte
    cmp al, -1
    je exit_prog

    print_char al
    jmp filter_stage

  exit_prog:
    exit 0
  exit_and_print_help:
    call print_help
    ; ================== program end =========================

code_segment ends
end start
