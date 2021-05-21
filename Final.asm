; CAMERON BINIAMOW
; ECEN 3320
; LAB 2.4: 8051 ASSEMBLY LANGUAGE PROGRAMMING
; DUE: 10/30/2020

  ORG     0H
  ACALL   LCD_INIT
  ACALL   READ                ; READ INPUT VALUE
  ACALL   RANDOM              ; CREATE RANDOM NUMBER
  MOV     R6, A               ; HOLD FIRST RANDOM NUMBER IN R6
  ACALL   RANDOM              ; CREATE SECOND RANDOM NUMBER
  MOV     B, A                ; REG B = SECOND RANDOM NUMBER
  MOV     DPTR, #FIRST        ; LOAD ROM POINTER
  ACALL   LCD_STRING1         ; WRITE "FIRST: "
  MOV     A, R6               ; REG A = FIRST RANDOM NUMBER
  ACALL   CONVERT
  ACALL   LCD_2NDLINE         ; MOVE CURSOR THE 2nd LINE OF LCD
  MOV     DPTR, #SECOND       ; LOAD ROM POINTER
  ACALL   LCD_STRING1         ; WRITE "SECOND: "
  MOV     A, B                ; LOAD 2nd RAND NUM INTO REG A
  MOV     R6, A               ; HOLD COPY OF SECOND RANDOM NUMBER
  ACALL   CONVERT

HERE:
  SJMP    HERE                ; STAY HERE


;---------------------------------------------------------------------
; UNPACKS BCD

CONVERT:
  MOV     R1, #0F0H
  ANL     A, R1               ; MASK UPPER NIBBLE
  SWAP    A                   ; PLACE UPPER NIBBLE INTO LOWER NIBBLE
  ACALL   WRITE               ; WRITE BIN. FOR UPPER NIBBLE OF RAND NUM
  MOV     A, R6               ; ORIGINAL UNMASKED VALUE
  MOV     R1, #0FH
  ANL     A, R1               ; MASK LOWER NIBBLE
  ACALL   WRITE               ; WRITE BIN. FOR LOWER NIBBLE OF RAND NUM
  RET
  
  
;---------------------------------------------------------------------
; READS PACKED BCD VALUE FROM PORT3

READ:
  CLR     A
  MOV     A, P3               ; STORE VALUE READ FROM PORT3
  RET


;---------------------------------------------------------------------
; CREATES RANDOM VALUE

RANDOM:
  RLC     A                   ; SHIFT LEFT ONCE
  MOV     R1, A               ; R1 = READ VALUE SHIFTED LEFT ONCE
  MOV     R2, A               ; R2 = READ VALUE SHIFTED LEFT ONCE
  RLC     A                   ; A = READ VALUE SHIFTED LEFT TWICE
  XRL     A, R2
  ANL     A, #80H             ; A.7 = XOR OF R1.6 & R1.7 (X000 0000)
  SWAP    A                   ; A = 0000 X000
  RR      A                   ; A = 0000 0X00
  RR      A                   ; A = 0000 00X0
  RR      A                   ; A = 0000 000X
  MOV     R2, A
  MOV     A, R1
  ANL     A, #7EH             ; A = 0XXX XXX0
  ORL     A, R2               ; A = 0XXX XXXX (RANDOM NUMBER – FINAL)
  RET


;---------------------------------------------------------------------
; WRITES A BYTE OF BINARY VALUES

WRITE:
  CJNE    A, #00H, L1         ; LOWER NIBBLE OF A = 0? NO – CHECK NEXT
  MOV     DPTR, #ZERO         ; YES – WRITE 0000
  ACALL   LCD_STRING
  RET
L1:
  CJNE    A, #01H, L2         ; LOWER NIBBLE OF A = 1? NO – CHECK NEXT
  MOV     DPTR, #ONE          ; YES – WRITE 0001
  ACALL   LCD_STRING
  RET
L2:
  CJNE    A, #02H, L3         ; LOWER NIBBLE OF A = 2? NO – CHECK NEXT
  MOV     DPTR, #TWO          ; YES – WRITE 0010
  ACALL   LCD_STRING
  RET
L3:
  CJNE    A, #03H, L4         ; LOWER NIBBLE OF A = 3? NO – CHECK NEXT
  MOV     DPTR, #THREE        ; YES – WRITE 0011
  ACALL   LCD_STRING
  RET
L4:
  CJNE    A, #04H, L5         ; LOWER NIBBLE OF A = 4? NO – CHECK NEXT
  MOV     DPTR, #FOUR         ; YES – WRITE 0100
  ACALL   LCD_STRING
  RET
L5:
  CJNE    A, #05H, L6         ; LOWER NIBBLE OF A = 5? NO – CHECK NEXT
  MOV     DPTR, #FIVE         ; YES – WRITE 0101
  ACALL   LCD_STRING
  RET
L6:
  CJNE    A, #06H, L7         ; LOWER NIBBLE OF A = 6? NO – CHECK NEXT
  MOV     DPTR, #SIX          ; YES – WRITE 0110
  ACALL   LCD_STRING
  RET
L7:
  CJNE    A, #07H, L8         ; LOWER NIBBLE OF A = 7? NO – CHECK NEXT
  MOV     DPTR, #SEVEN        ; YES – WRITE 0111
  ACALL   LCD_STRING
  RET
L8:
  CJNE    A, #08H, L9         ; LOWER NIBBLE OF A = 8? NO – CHECK NEXT
  MOV     DPTR, #EIGHT        ; YES – WRITE 1000
  ACALL   LCD_STRING
  RET
L9:
  CJNE    A, #09H, L10        ; LOWER NIBBLE OF A = 9? NO – CHECK NEXT
  MOV     DPTR, #NINE         ; YES – WRITE 1001
  ACALL   LCD_STRING
  RET
L10:
  CJNE    A, #0AH, L11        ; LOWER NIBBLE OF A = 10? NO – CHECK NEXT
  MOV     DPTR, #TEN          ; YES – WRITE 1010
  ACALL   LCD_STRING
  RET
L11:
  CJNE    A, #0BH, L12        ; LOWER NIBBLE OF A = 11? NO – CHECK NEXT
  MOV     DPTR, #ELEVEN       ; YES – WRITE 1011
  ACALL   LCD_STRING
  RET
L12:
  CJNE    A, #0CH, L13        ; LOWER NIBBLE OF A = 12? NO – CHECK NEXT
  MOV     DPTR, #TWELVE       ; YES – WRITE 1100
  ACALL   LCD_STRING
  RET
L13:
  CJNE    A, #0DH, L14        ; LOWER NIBBLE OF A = 13? NO – CHECK NEXT
  MOV     DPTR, #THIRTEEN     ; YES – WRITE 1101
  ACALL   LCD_STRING
  RET
L14:
  CJNE    A, #0EH, L15        ; LOWER NIBBLE OF A = 14? NO – CHECK NEXT
  MOV     DPTR, #FOURTEEN     ; YES – WRITE 1110
  ACALL   LCD_STRING
  RET
L15:
  MOV     DPTR, #FIFETEEN     ; WRITE 1111
  ACALL   LCD_STRING
  RET


;---------------------(n)ms DELAY PROCEDURE---------------------------
;CALLS DELAY PROCEDURE n # OF TIMES. n = VALUE LOADED INTO REG A

DELAY_ms:
  MOV     R5, A               ; REGISTER A HOLDS # OF ms DELAY NEEDED
JUMP:
  ACALL   DELAY
  DJNZ    R5, JUMP            ; CONITUALLY DECREMENT R5 UNTIL 0
  RET


;---------------------1ms DELAY PROCEDURE-----------------------------
;DECREMENTS R4 FROM 255 TO 0 THEN DECREMENTS R3.
;CONTINUES LOOPS UNTIL R3 IS 0. CREATES 12750 CLOCKS ~1ms.

DELAY:
  MOV     R3, #50               ; LOAD 50 (DEC) INTO R3
HERE0:
  MOV     R4, #255              ; LOAD 255 DEC INTO R4
HERE2:
  DJNZ    R4, HERE2             ; CONTINUALLY DECREMENT R4 UNTIL 0
  DJNZ    R3, HERE0             ; DECREMENTS R3 UNTIL 0
  RET


;---------------------LCD INITIALIZE PROCEDURE------------------------
;INITIALIZES THE LCD IN ACCORDANCE TO THE LCD DATA SHEET

LCD_INIT:
  MOV     A, #15                ; 15ms DELAY
  ACALL   DELAY_ms
  MOV     A, #000H
  MOV     P1, A                 ; SET PORT 1 AS OUTPUT
  MOV     P3, A                 ; SET PORT 3 AS OUTPUT
  MOV     A, #30H               ; FUNCTION SET COMMAND
  ACALL   LCD_CMD
  MOV     A, #5                 ; 5ms DELAY
  ACALL   DELAY_ms
  MOV     A, #30H               ; FUNCTION SET COMMAND
  ACALL   LCD_CMD
  ACALL   DELAY                 ; 1ms DELAY
  MOV     A, #30H               ; FUNCTION SET COMMAND
  ACALL   LCD_CMD
  MOV     A, #3CH               ; FUNCTION SET COMMAND
  ACALL   LCD_CMD               ; 8-BIT INTERFACE
  MOV     A, #08H               ; DISPLAY OFF
  ACALL   LCD_CMD
  MOV     A, #06H               ; ENTRY MODE SET
  ACALL   LCD_CMD
  MOV     A, #0FH               ; DISPLAY ON
  ACALL   LCD_CMD
  ACALL   LCD_CLEAR             ; CLEAR DISPLAY
  RET


;---------------------LCD DATA PROCEDURE------------------------------
;TRANSFERS DATA TO THE LCD

LCD_DATA:
  SETB    P2.0                  ; RS = 1
  CLR     P2.1                  ; RW = 0
  ACALL   DELAY                 ; 1ms DELAY
  SETB    P2.2                  ; EN = 1
  ACALL   DELAY                 ; 1ms DELAY
  MOV     P1, A                 ; REGISTER A -> PORT 1
  ACALL   DELAY                 ; 1ms DELAY
  CLR     P2.2                  ; EN = 0
  RET


;---------------------LCD COMMAND PROCEDURE---------------------------
;USED TO EXECUTE ALL COMMANDS ON THE LCD

LCD_CMD:
  CLR     P2.0                  ; RS = 0
  CLR     P2.1                  ; RW = 0
  ACALL   DELAY                 ; 1ms DELAY
  SETB    P2.2                  ; EN = 1
  ACALL   DELAY                 ; 1ms DELAY
  MOV     P1, A                 ; REGISTER A -> PORT 1
  ACALL   DELAY                 ; 1ms DELAY
  CLR     P2.2                  ; EN = 0
  RET


;---------------------LCD CLEAR PROCEDURE-----------------------------
;CLEARS THE LCD

LCD_CLEAR:
  MOV     A, #01H
  ACALL   LCD_CMD
  RET


;---------------------LCD CHAR PROCEDURE------------------------------
;WRITE A SINGLE CHARACTER ON THE LCD

LCD_CHAR:
  ACALL   LCD_DATA
  RET


;---------------------LCD 2ND LINE PROCEDURE--------------------------
;MOVES CURSORS TO THE SECOND LINE OF THE LCD

LCD_2NDLINE:
  MOV     A, #0C0H
  ACALL   LCD_CMD
  RET


;---------------------LCD STRING PROCEDURE----------------------------
;WRITES A STRING ON THE LCD

LCD_STRING1:
L3S:
  CLR     A
  MOVC    A, @A+DPTR
  ACALL   LCD_DATA
  ACALL   DELAY
  INC     DPTR
  JZ      L4S
  SJMP    L3S
L4S:
  RET
LCD_STRING:
  MOV     R7, #4
L3B:
  CLR     A
  MOVC    A, @A+DPTR
  ACALL   LCD_DATA
  ACALL   DELAY
  INC     DPTR
  DJNZ    R7, L3B
  RET


;---------------------STRINGS-----------------------------------------
ORG 300H

FIRST:
  DB      "FIRST: ", 0
SECOND:
  DB      "SECOND:", 0
ZERO:
  DB      "0000"
ONE:
  DB      "0001"
TWO:
  DB      "0010"
THREE:
  DB      "0011"
FOUR:
  DB      "0100"
FIVE:
  DB      "0101"
SIX:
  DB      "0110"
SEVEN:
  DB      "0111"
EIGHT:
  DB      "1000"
NINE:
  DB      "1001"
TEN:
  DB      "1010"
ELEVEN:
  DB      "1011"
TWELVE:
  DB      "1100"
THIRTEEN:
  DB      "1101"
FOURTEEN:
  DB      "1110"
FIFETEEN:
  DB      "1111"
END
