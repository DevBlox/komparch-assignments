%title 'XOR string encryptor'

model small
assume ss:stack_segment, ds:data_segment, cs:code_segment

stack_segment segment para stack 'stack'
    db 100h dup(0)
stack_segment ends

data_segment segment para public 'data'
    message db 'Enter two strings', 10, 13, '$'
    string_buffer_size equ 100
    string_one db string_buffer_size dup('$')
    string_two db string_buffer_size dup('$')
data_segment ends

code_segment segment para public 'code'
    locals @@
    include utils.inc

    start:
        load_data_segment data_segment
        print message

        stdin_prepare_buffer string_one, string_buffer_size
        stdin_buffer_read string_one
        mov bx, 02h
        print string_one + bx
        print string_one + bx
        print string_one + bx

        exit 0
code_segment ends
end start
