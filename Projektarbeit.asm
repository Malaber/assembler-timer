
DIGIT_0 EQU 0x10
DIGIT_1 EQU 0x11
DIGIT_2 EQU 0x12
DIGIT_3 EQU 0x13

COUNT_TIME_BUTTON EQU P0.7
INCREMENT_BUTTON EQU P1.7
RESET_BUTTON EQU P2.7

TIMER_CTR EQU R2

org 00h
  JMP init

org 0Bh
  JMP timer0_isr

timer0_isr:
  CLR TR0

  MOV TH0, #0F0h
  MOV TL0, #060h

  INC TIMER_CTR
  CJNE TIMER_CTR, #250, timer0_end
    ACALL increment
    MOV TIMER_CTR, #0
  timer0_end:

  SETB TR0
  RETI

init:
  MOV P0,#0xBF
  MOV P1,#0xBF
  MOV P2,#0xBF
  MOV P3,#0xBF

  MOV TMOD, #09h
  MOV TH0, #0F0h
  MOV TL0, #060h
  SETB TR0
  CLR ET0
  SETB EA

main_loop:
  if_counter_enabled:
    JNB COUNT_TIME_BUTTON, end_if_counter_enabled
    JB ET0, end_if_counter_enabled
    MOV TH0, #0F0h
    MOV TL0, #060h
    SETB ET0
  end_if_counter_enabled:
  if_counter_disabled:
    JB COUNT_TIME_BUTTON, end_if_counter_disabled
    CLR ET0
  end_if_counter_disabled:
  if_increment_pressed:
    JNB INCREMENT_BUTTON, end_if_increment_pressed
    ACALL increment
    while_increment_pressed:
      JB INCREMENT_BUTTON, while_increment_pressed
  end_if_increment_pressed:
  if_reset_pressed:
    JNB RESET_BUTTON, end_if_reset_pressed
    ACALL reset_digits
    while_reset_pressed:
      JB RESET_BUTTON, while_reset_pressed
  end_if_reset_pressed:
  JMP main_loop

increment:
  MOV R3, DIGIT_0
  CJNE R3, #09h, increment_ones
  MOV DIGIT_0, #00h
  MOV R3, DIGIT_1
  CJNE R3, #09h, increment_tens
  MOV DIGIT_1, #00h
  MOV R3, DIGIT_2
  CJNE R3, #09h, increment_hundrets
  MOV DIGIT_2, #00h
  MOV R3, DIGIT_3
  CJNE R3, #09h, increment_thousands
  MOV DIGIT_3, #00h
  JMP display3

increment_ones:
  INC DIGIT_0
  JMP display0

increment_tens:
  INC DIGIT_1
  JMP reset_digits_0

increment_hundrets:
  INC DIGIT_2
  JMP reset_digits_1

increment_thousands:
  INC DIGIT_3
  JMP reset_digits_2

reset_digits:
  MOV DIGIT_3, #00h
reset_digits_2:
  MOV DIGIT_2, #00h
reset_digits_1:
  MOV DIGIT_1, #00h
reset_digits_0:
  MOV DIGIT_0, #00h

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

END
