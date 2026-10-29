	OPT	2		; Turn Listing Off

; ===================================================
; Test Harness - DO NOT CHANGE
; ===================================================

	AREA	TestHarness, CODE

Harness
	MOV	R11, LR		; Save the return address

	LDR	R0, HReturn
	ORRS	R0, R0, R0
	MOVNE	PC, R0

; Report current status to the user
HStatus
	LDR	R10, =MSG	; Display Time
	BLAL	ASCIIZ
	LDR	R0, Time	; Read time
	BLAL	ShowTime	; Display it

	BLAL	ASCIIZ		; Display Alarm setting
	LDR	R0, Alarm	; Read Alarm setting
	BLAL	ShowTime	; Display it

	LDRB	R0, Klaxon	; Read Klaxon Status

	ORRS	R0, R0, R0	; Is it clear ?
	BLNE	ASCIIZ		; No => Display Status

; Prompt the user for the next command

	LDR	R10, =Prompt	; Point to prompt text
	BLAL	ASCIIZ

	SWI	&4		; Read char from keyboard

	CMP	R0, #'a'	; Is char lower case?
	SUBGE	R0, R0, #' '	; Yes => Convert to upper case


; Lookup command in command table

	LDR	R10, =Command	; Start of command table
	EOR	R3, R3, R3	; Counter (command)

HCmd	LDRB	R1, [R10], #1	; Read command letter
	ORRS	R1, R1, R1	; Is it end of table?
	BEQ	HStatus		; No => Go around again

	CMP	R1, R0		; Is it this command?
	BEQ	doCommand	; Yes => Execute it

	; Skip to next command letter
HSkip	LDRB	R1, [R10], #1
	ORRS	R1, R1, R1	; Is it zero?
	BNE	HSkip
	ADD	R3, R3, #1	; Increment command count
	BAL	HCmd		; Look at next command

doCommand
	; Display command text
	BLAL	ASCIIZ

	LDR	R10, =JumpTable	; Point to jump table

	LDR	PC, [R10, R3, LSL #2] ; Jump to function

; ===================================================
;
; Time Mode (T)
; Modify current time
; Set the Time bit (bit 0) in the Keyboard matrix.

HTime
	MOV	R0, #0x01	; 0000 0001 (Time Bit)
	STRB	R0, KeyCode	; Set Keyboard Matrix
	BAL	HStatus

; ===================================================
;
; Alarm Mode (A)
; Modify Alarm time
; Set the Alarm bit (bit 1) in the Keyboard matrix.

HAlarm
	MOV	R0, #0x02	; 0000 0010 (Alarm Bit)
	STRB	R0, KeyCode	; Set Keyboard Matrix
	BAL	HStatus

; ===================================================
;
; Snooze (S)
; Hit the Snooze button - Set the Snooze bit (bit 4)
; in the Keyboard matrix and then call the students
; keyboard handler.

HSnooze
	MOV	R0, #0x10	; 0001 0000 (Snooze Bit)
	BLAL	HKeyboard	; Call Student's code

	EOR	R0, R0, R0
	STRB	R0, KeyCode	; Clear Keyboard Matrix
	BAL	HStatus

; ===================================================
;
; Hours (H)
; Increment Hours of current mode (Time or Alarm)
; Set the Hour bit in the keyboard matrix, leaving
; the current mode set. Then call the students keyboard
; handler.

HHour
	MOV	R1, #0x04	; 0000 0100 (Hour Bit)
	BAL	HKey		; Call Student's code

; ===================================================
;
; Minutes (M)
; Increment Minute of current mode (Time or Alarm)
; Set the Minute bit in the keyboard matrix, leaving
; the current mode set. Then call the students keyboard
; handler.

HMinute
	MOV	R1, #0x08	; 0000 1000 (Minute Bit)

; This code can lead to the user pushing the Minute or
; Hour button without setting a Mode. The students code
; is going to have to process this possibility.

HKey
	LDRB	R0, KeyCode	; Read current matrix

	AND	R0, R0, #0x03	; Keep the Mode bits
	ORR	R0, R0, R1	; Set Key bit (H or M)
	BLAL	HKeyboard	; Call Student's code
	BAL	HStatus

HKeyboard
	MVN	R1, R0
	ORR	R0, R0, R1, LSL #5
	STRB	R0, KeyCode

	STR	LR, HReturn	; Save return address

	LDR	R12, =UserCode
	LDR	R12, [R12]
	MOV	PC, R11		; Call Student's code

; ===================================================
;
; Tick (Space)
; This is a bit of a cheat. It is here to allow the student
; to test their tick code without worrying about it ticking
; away every second.

HTick
	EOR	R0, R0, R0
	STR	R0, HReturn	; Save Harness Status

	LDR	R12, =UserCode
	LDR	R12, [R12, #4]
	MOV	PC, R11		; Call Student's code

; ===================================================
;
; Quit (Q)
; Stop the harness and return to the monitor

HQuit
	SWI	&11

; ===================================================
; Display - Display the time in R0

ShowTime
	MOV	R9, LR		; Save Return address

	AND	R1, R0, #0xFF	; R1 = Minutes
	MOV	R2, R0, LSR #8	; R2 = Hours
	
	MOV	R0, R2
	BLAL	ShowTwo		; Display Hours

	MOV	R0, #':'
	SWI	&0		; Display ":"

	MOV	R0, R1		; Display Minutes
	MOV	LR, R9		; Recover Return Address

ShowTwo
	MOV	R3, R0		; Save Second nibble
	MOV	R0, #'0'	; ASCII "0"
	ADD	R0, R0, R3, LSR #4 ; Add first nibble
	SWI	&0		; Display it

	MOV	R0, #'0'	; ASCII "0"
	AND	R3, R3, #0xF	; Disregard first Nibble
	ADD	R0, R0, R3	; Add to ASCII "0"
	SWI	&0		; Display char

	MOV	PC, LR		; Return

; Display ASCIIZ String
; R10 points to the zero terminated string
; R0  reset to zero

ASCIIZ	LDRB	R0, [R10], #1	; Read in the character, inc R10
	CMP	R0, #0		; Is char zero terminator ?
	MOVEQ	PC, LR		; Yes => Return to caller
	SWI	&0		; No  => Display char (R0)
	BAL	ASCIIZ		; Next char

	OPT	4		; New Page

; ===================================================
; Private Data Section for the Test Harness
; ===================================================

;	AREA	HarnessData, DATA

MSG	DCB	13,10,"Time: ",0
	DCB	" Alarm: ",0
	DCB	" [Alarm]",0

Prompt	DCB	" ? ",0

Command
	DCB	"T", 13,10,"Time Mode",0
	DCB	"A", 13,10,"Alarm Mode",0
	DCB	"H", "our",0
	DCB	"M", "inute",0
	DCB	"S", "nooze",0
	DCB	" ", "Tick",0
	DCB	"Q", "uit",13,10,0
	DCB	0

	ALIGN
JumpTable
	DCD	HTime
	DCD	HAlarm
	DCD	HHour
	DCD	HMinute
	DCD	HSnooze
	DCD	HTick
	DCD	HQuit

UserCode
	DCD	Keyboard
	DCD	Tick
	
HReturn	DCD	0

; ===================================================
; End of Test Harness
; ===================================================

	OPT	4		; New Page

	END