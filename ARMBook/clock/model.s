	TTL	- Alarm Clock - Model Answer by Peter Knaggs

; ===================================================
	AREA	Program, CODE, READONLY
; ===================================================

; Define a few Magic Numbers (constants) to make life easier

KLXON	EQU	0xFF
KLXOFF	EQU	0x00

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
	LDRB	R0, Seconds	; Count seconds on each tick
	ADD	R0, R0, #1	; Increment seconds counter
	CMP	R0, #60		; Have we reached a minuate yet
	MOVEQ	R0, #0		; Yes => Reset to zero seconds
	STRB	R0, Seconds	; Save the second count
	MOVNE	PC, LR		; Return if not at minuate rollover

; We have just passed the 60 second mark so we need to increment
; the time. We do this in stages, one digit at a time, starting
; with the minutes (units).

	LDR	R0, Time	; Read the current time
	ADD	R0, R0, #1	; Add one minuate to it

	AND	R1, R0, #0x0F	; Have we 10 minuates?
	CMP	R1, #0x0A
	BLT	TestAlarm	; No => Check Alarm status

; We have 10 minuates so we need to move on the the next digit.

	ADD	R0, R0, #0x06	; Addjust R0 to a BCD value
	AND	R1, R0, #0x0FF	; We only want the minuates values
	CMP	R1, #0x60	; Have we reached 60 minutes?
	BLT	TestAlarm	; No => Check Alarm Status

; 60 Minuates have passed so we need to increment the hour value

	ADD	R0, R0, #0xA0	; Inc single hour count (reset min to zero)
	CMP	R0, #0x0A00	; Have we had 10 hours ?
	MOVEQ	R0, #0x1000	; Yes => BCD Adjust to 10:00
	CMP	R0, #0x1300	; Have we run over 12 ?
	MOVEQ	R0, #0x0100	; Yes => Reset to 01:00


; We have now updated the time, so it is time to check to see what
; we need to do to the Klaxon.

TestAlarm
	; Save our new Time before we do anything else
	STR	R0, Time	; Save our modified time

	; Now we can check to see if the Alarm should be sounding

	; Turn Klaxon Off
	; If Current Time = Alarm Time Then
	;	Set Alarm Count to 60
	;	Set Snooze Count to 0
	; Else
	;	Read current Alarm Count
	;	Read current Snooze Count
	; End If
	; If Alarm Count > 0 Then
	;	Turn Klaxon On
	;	Decrement Alarm Count
	;	If Snooze Count > 0 Then
	;		Turn Klaxon back off
	;		Decrement Snooze Count
	;	End If
	; End If

	MOV	R3, #KLXOFF	; Turn Klaxon Off

	LDR	R1, Alarm	; Read alarm setting
	CMP	R0, R1		; Is Current time same as Alarm Time

	MOVEQ	R1, #60		; Yes => Set Alarm  Counter to 60 minutes
	MOVEQ	R2, #0		;        Set Snooze Counter to 0 minutes

	LDRNEB	R1, Counter	; No  => Read current Alarm  Counter
	LDRNEB	R2, Snooze	;        Read current Snooze Counter

	CMP	R1, #0		; Is Alarm Counter > 0
	BEQ	SetKlaxon	; No  => Ensure Klaxon is off

	MOV	R3, #KLXON	; Yes => Turn Klaxon On
	SUB	R1, R1, #1	; 	 Decrement Alarm Counter
	STRB	R1, Counter

	CMP	R2, #0		; Is Snooze Counter > 0 ?
	BEQ	SetKlaxon	; Yes => Ensure Klaxon in On

	MOV	R3, #KLXOFF	; No  => Turn the bloody klaxon off
	SUB	R2, R2, #1	; 	 Decrement Snooze Counter
	STRB	R2, Snooze

SetKlaxon
	STRB	R3, Klaxon	; Set Klaxon On or Off
	MOV	PC, LR		; Return to harness

	OPT	4		; New page

; ===================================================
; Keyboard
; ===================================================
;
; This routine is called when the user presses any of
; the control buttons on the alarm clock. The keyboard
; consists of just four keys. The KEYCODE variable holds
; the value for the keyboard matrix as follows:
;
; Bit 7  Bit 6  Bit 5  Bit 4  Bit 3  Bit 2  Bit 1  Bit 0
; Unused Unused Unused Snooze Minute Hour   Alarm  Time
;
; To set the alarm time the user must hold the "Alarm"
; key down and press the "Hour" key to increment the
; Alarm time by one hour.
;
; This routine should read the keyboard by reading the
; KEYCODE variable and modify the Current Time or the
; Alarm time accordingly.

Keyboard
	LDRB	R0, KeyCode	; Read the Keyboard Code

	ANDS	R1, R0, #0x10	; Is the Snooze key pressed
	BEQ	NotSnooze	; No  => Skip Snooze handling

	MOV	R1, #10		; Set Snooze counter to 10 minuets
	STRB	R1, Snooze
	MOV	R1, #KLXOFF	; Turn Klaxon off
	STRB	R1, Klaxon
	MOV	PC, LR		; Return to harness

NotSnooze
	ANDS	R1, R0, #0x01	; Is the Time key pressed ?
	LDRNE	R1, Time	; Yes => Read Current Time
	LDREQ	R1, Alarm	; No  => Read Current Alarm

	ANDS	R2, R0, #0x08	; Is Minute Key pressed?
	BEQ	IncHour		; No => Increment Hour then

IncMin
	ADD	R1, R1, #1	; Increment Minute value
	AND	R2, R1, #0x0F	; Check last digit
	CMP	R2, #0x0A	; is over 9
	ADDGE	R1, R1, #0x06	; BCD Adjust 0A to 10
	AND	R2, R1, #0xFF	; Check minutes value
	CMP	R2, #0x60	; Have we reaced 60 minutes ?
	ANDEQ	R1, R1, #0xFF00	; Yes => Reset minutes to zero
	BAL	EndKbd		; Save new time

IncHour
	ADD	R1, R1, #0x0100	; Increment Hour value
	AND	R2, R1, #0xFF00	; Ignore minutes value
	CMP	R2, #0x0A00	; Is it over 9
	ADDEQ	R1, R1, #0x0600	; Yes => BCD Adjust to 10:xx
	CMP	R2, #0x1300	; Is it over 12
	SUBGE	R1, R1, #0x1200 ; Yes => Roll the clock over

EndKbd
	ANDS	R2, R0, #0x01	; Did we update the Time ?
	STRNE	R1, Time	; Yes => Save new Time
	STREQ	R1, Alarm	; No  => Save new Alarm

	MOV	PC, LR		; Return to harness

	OPT	4	; New Page

; ===================================================
	AREA	Data, DATA
; ===================================================

; Current time and Alarm time are both stored as Binary
; Coded Decimal values. I.e., $1234 represents 12:34 or
; thirty four minutes past 12.

Time	DCD	0x0959	; Current Time in BCD	(12:34)
Alarm	DCD	0x1240	; Alarm Time in BCD	(12:40)

Klaxon 	DCB	0	; $00 is Off, $FF is On
KeyCode	DCB	0	; Keyboard Matrix

; Any additional variable you require should be placed
; here.

Counter	DCB	0	; Alarm Counter (minutes)
Seconds	DCB	0	; Second Counter
Snooze	DCB	0	; Snooze Counter (minutes)

	END
