
DIGIT_0 EQU 0x10
DIGIT_1 EQU 0x11
DIGIT_2 EQU 0x12
DIGIT_3 EQU 0x13

INCREMENT_BUTTON EQU P0.7

org 0x0
  JMP init

init:
  MOV P0,#0xBF
  MOV P1,#0x3F
  MOV P2,#0x3F
  MOV P3,#0x3F

main_loop:
  if_increment_pressed:
    JNB INCREMENT_BUTTON, end_if_increment_pressed
    ACALL increment
    while_increment_pressed:
      JB INCREMENT_BUTTON, while_increment_pressed
  end_if_increment_pressed:
  JMP main_loop

increment:
  MOV R3, DIGIT_0
  CJNE R3, #09h, increment_ones
  MOV R3, DIGIT_1
  CJNE R3, #09h, increment_tens
  MOV R3, DIGIT_2
  CJNE R3, #09h, increment_hundrets
  MOV R3, DIGIT_3
  CJNE R3, #09h, increment_thousands
  JMP reset_digits
  RET

increment_ones:
  INC DIGIT_0
  JMP display0

increment_tens:
  MOV DIGIT_0, #00h
  INC DIGIT_1
  JMP display1

increment_hundrets:
  MOV DIGIT_0, #00h
  MOV DIGIT_1, #00h
  INC DIGIT_2
  JMP display2

increment_thousands:
  MOV DIGIT_0, #00h
  MOV DIGIT_1, #00h
  MOV DIGIT_2, #00h
  INC DIGIT_3
  JMP display3

reset_digits:
  MOV DIGIT_0, #00h
  MOV DIGIT_1, #00h
  MOV DIGIT_2, #00h
  MOV DIGIT_3, #00h
  JMP display3

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
  RET

org 300h
display_codes:
  db 0xBF, 0x86, 0xDB, 0xCF, 0xE6
  db 0xED, 0xFD, 0x87, 0xFF, 0xEF

