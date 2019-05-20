
org 0x0
jmp init

init:
MOV P0,#0xBF
MOV P1,#0x3F
MOV P2,#0x3F
MOV P3,#0x3F

loop:
if_increment_pressed:
JNB P0.7, end_if_increment_pressed
ACALL increment
while_increment_pressed:
JB P0.7, while_increment_pressed
end_if_increment_pressed:
JMP loop

increment:
JMP inc0
RET



loopinc0:
inc 0x10
jmp display0

loopinc1:
inc 0x11
jmp display1

loopinc2:
inc 0x12
jmp display2

loopinc3:
inc 0x13
jmp display3

inc0:
mov R3, 0x10
cjne R3 ,#0x09,loopinc0
jmp inc1

inc1:
mov 0x10,#0x00
mov R4, 0x11
cjne R4 ,#0x09,loopinc1
jmp inc2

inc2:
mov 0x11,#0x00
mov R4, 0x12
cjne R4 ,#0x09,loopinc2
jmp inc3

inc3:
mov 0x12,#0x00
mov R4, 0x13
cjne R4 ,#0x09,loopinc3
jmp res

res:
mov 0x13,#0x00
jmp display3

display3:
MOV A, 0x13
MOV DPTR, #display_codes
MOVC A,@A+DPTR
MOV P3, A

display2:
MOV A, 0x12
MOV DPTR, #display_codes
MOVC A, @A+DPTR
MOV P2, A

display1:
MOV A, 0x11
MOV DPTR, #display_codes
MOVC A, @A+DPTR
MOV P1, A

display0:
MOV A, 0x10
MOV DPTR, #display_codes
MOVC A, @A+DPTR
MOV P0, A
JMP loop

org 300h
display_codes:
db 0xBF, 0x86, 0xDB, 0xCF, 0xE6
db 0xED, 0xFD, 0x87, 0xFF, 0xEF

