
DIGIT_0 EQU 0x10
DIGIT_1 EQU 0x11
DIGIT_2 EQU 0x12
DIGIT_3 EQU 0x13

INCREMENT_BUTTON EQU P0.7

org 0x0
jmp init

init:
MOV P0,#0xBF
MOV P1,#0x3F
MOV P2,#0x3F
MOV P3,#0x3F

loop:
if_increment_pressed:
JNB INCREMENT_BUTTON, end_if_increment_pressed
ACALL increment
while_increment_pressed:
JB INCREMENT_BUTTON, while_increment_pressed
end_if_increment_pressed:
JMP loop

increment:
JMP inc0
RET



loopinc0:
inc DIGIT_0
jmp display0

loopinc1:
inc DIGIT_1
jmp display1

loopinc2:
inc DIGIT_2
jmp display2

loopinc3:
inc DIGIT_3
jmp display3

inc0:
mov R3, DIGIT_0
cjne R3, #0x09, loopinc0
jmp inc1

inc1:
mov DIGIT_0, #0x00
mov R4, DIGIT_1
cjne R4, #0x09, loopinc1
jmp inc2

inc2:
mov DIGIT_1, #0x00
mov R4, DIGIT_2
cjne R4, #0x09, loopinc2
jmp inc3

inc3:
mov DIGIT_2, #0x00
mov R4, DIGIT_3
cjne R4, #0x09, loopinc3
jmp res

res:
mov DIGIT_3, #0x00
jmp display3

display3:
MOV A, DIGIT_3
MOV DPTR, #display_codes
MOVC A,@A+DPTR
MOV P3, A

display2:
MOV A, DIGIT_2
MOV DPTR, #display_codes
MOVC A, @A+DPTR
MOV P2, A

display1:
MOV A, DIGIT_1
MOV DPTR, #display_codes
MOVC A, @A+DPTR
MOV P1, A

display0:
MOV A, DIGIT_0
MOV DPTR, #display_codes
MOVC A, @A+DPTR
MOV P0, A
JMP loop

org 300h
display_codes:
db 0xBF, 0x86, 0xDB, 0xCF, 0xE6
db 0xED, 0xFD, 0x87, 0xFF, 0xEF

