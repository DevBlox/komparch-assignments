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
    encrypted db string_buffer_size dup('$')
    string_one_length dw 0
    string_two_length dw 0
data_segment ends

code_segment segment para public 'code'
    locals @@
    include utils.inc

    start:
        load_data_segment data_segment

        ; preparing first string
        print message
        prepare_buffer string_one, string_buffer_size
        stdin_buffer_read string_one
        buflen string_one, string_one_length

        ; preparing second string
        print message2
        prepare_buffer string_two, string_buffer_size
        stdin_buffer_read string_two
        buflen string_two, string_two_length

        ; the first string should be bigger
        ; this is done to avoid complicated checks
        ; while inside the loop
        ; di -> contains the shorter string
        ; si -> contains the longer string
        ; cx -> contains the shorter string length
        ; dx -> contains the longer string length
        xor bx, bx ; nullify offset counter
        mov cx, string_one_length
        cmp cx, string_two_length
        jl two_is_bigger
        load_buffer si, string_one
        load_buffer di, string_two
        mov cx, string_two_length
        mov dx, string_one_length
        jmp encrypt_start
    two_is_bigger:
        load_buffer di, string_one
        load_buffer si, string_two
        mov dx, string_two_length

    ; the first stage applies xor
    encrypt_start:
        cmp bx, cx
        je stage_two
        mov ah, di[bx]
        xor ah, si[bx]
        mov encrypted[bx], ah
        inc bx
        jmp encrypt_start

    ; the second stage copies remaining characters from the longer string
    stage_two:
        cmp bx, dx
        je end_encryption
        mov ah, si[bx]
        mov encrypted[bx], ah
        inc bx
        jmp stage_two

    ; prints out the encrypted string
    end_encryption:
        terminate_string encrypted, bx
        print result_message
        print encrypted

        exit 0
code_segment ends
end start
