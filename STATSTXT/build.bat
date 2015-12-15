@ECHO OFF
TASM /m2 /zi statstxt.asm
TLINK /v statstxt.obj
