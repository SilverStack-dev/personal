	TTL	- Alarm Clock - <Put Your Name Here>

; ===================================================
	AREA	Program, CODE, READONLY
; ===================================================

; Make things just a bit easier to debug !

	ENTRY
Main
	BLAL	Harness		; Call the test harness
	LDR	LR, =Main	; Set Return address
	MOV	PC, R12		; Call Students Code

; ===================================================
; Include the Test Harness
; ===================================================

	INCLUDE	harness.s
	OPT	1	; Turn Listing output on

; ===================================================
	AREA	Assignment, CODE, READONLY
; ===================================================

; ===================================================
; Tick
; ===================================================
;
; This routine is called once every second. It should:
;
;  Increment a seconds counter
;  If seconds counter == 60 then
;     reset seconds counter to zero
;     increment current time
;       increment minute count
;       if minute count == 60 then
;          reset minute count to zero
;          increment hour count
;          if hour count == 13 then
;             reset hour count to one
;          end if
;       end if
;     Ensure Klaxon is off
;     if current time == alarm time then
;        Turn Klaxon On
;     end if
;  end if

Tick
	NOP		; Your code goes in here.
	
	MOV	PC,LR	; Return to harness

	OPT	4	; New page

; ===================================================
; Keyboard
; ===================================================
;
; This routine is called when the user presses any of the control buttons on the alarm
; clock. The keyboard consists of just four keys. The KEYCODE variable holds the value
; for the keyboard matrix as follows:
;
; Bit 7   Bit 6   Bit 5   Bit 4   Bit 3   Bit 2   Bit 1   Bit 0
; Unused  Unused  Unused  Snooze  Minute  Hour    Alarm   Time
;
; To set the alarm time the user must hold the "Alarm" key down and press the "Hour"
; key to increment the Alarm time by one hour.
;
; This routine should read the keyboard by reading the KEYCODE variable and modify
; the Current Time or the Alarm time accordingly.

Keyboard
	LDRB	R0, KeyCode
	NOP		; Your code goes in here.

	MOV	PC, LR	; Return to harness


	OPT	4	; New Page

; ===================================================
	AREA	Data, DATA
; ===================================================

; Current time and Alarm time are both stored as Binary Coded Decimal values.
; I.e., $1234 represents 12:34 or thirty four minutes past 12.

Time	DCD	0x1234	; Current Time in BCD	(12:34)
Alarm	DCD	0x1240	; Alarm Time in BCD	(12:40)

Klaxon 	DCB	0	; $00 is Off, $FF is On
KeyCode	DCB	0	; Keyboard Matrix

; Any additional variable you require should be placed here.

	END
