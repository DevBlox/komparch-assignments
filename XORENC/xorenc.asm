.model small
.stack 100h
.data
    message db 'Enter two strings', 10, 13, '$'
    string_one db 100 dup(0)
    string_two db 100 dup(0)
    string_buffer_size dw 100
.code

    include utils.inc

    start:
        load_segment @data
        print message

        exit 0
