%title 'Text statistics counting program'

model small

assume ss:stack_segment, ds:data_segment, cs:code_segment

stack_segment segment para stack 'stack'
    db 100h dup(0)
stack_segment ends

data_segment segment para public 'data'
data_segment ends

code_segment segment para public 'code'
    include ..\COMMON\utils.inc

    start:

code_segment ends
end start
