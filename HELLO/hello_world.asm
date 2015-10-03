.model small
assume ss:stack_segment, ds:data_segment, cs:code_segment

stack_segment segment para stack 'stack'
	db 100h dup(0)
stack_segment ends

data_segment segment para public 'data'
	string db 'Hello world!$'
data_segment ends

code_segment segment para public 'code'
	locals @@
	
	start:
		mov ax, seg data_segment
		mov ds, ax
		
		lea dx, string
		mov ah, 09h
		int 21h
		
		int 4Ch
		
code_segment ends
end start