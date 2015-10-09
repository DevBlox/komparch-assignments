%title 'XOR string encryptor'

model small
assume ss:stack_segment, ds:data_segment, cs:code_segment

stack_segment segment para stack 'stack'
    db 100h dup(0)
stack_segment ends

data_segment segment para public 'data'
    message db 'Enter the first string: ', '$'
    message2 db 10, 13, 'Enter the second one: ', '$'
    result_message db 10, 13, 'The encrypted string is: ', '$'
    string_buffer_size equ 100
    string_one db string_buffer_size dup('$')
    string_two db string_buffer_size dup('$')
    string_one_length dw 0
    string_two_length dw 0
data_segment ends

code_segment segment para public 'code'
    locals @@
    include utils.inc

    start:
        load_data_segment data_segment

        print message
        prepare_buffer string_one, string_buffer_size
        stdin_buffer_read string_one
        buflen string_one, string_one_length

        print message2
        prepare_buffer string_two, string_buffer_size
        stdin_buffer_read string_two
        buflen string_two, string_two_length

        

        exit 0
code_segment ends
end start
