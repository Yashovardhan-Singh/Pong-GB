INCLUDE "include/hardware.inc"

SECTION "Functions", ROM0


; Memory Copy
; @param hl: destination
; @param de: source
; @param bc: length
MemCpy::
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, MemCpy
	ret


; Fill Memory
; @param a: value to write to memory
; @param b: length
; @param hl: start
MemFill::
	ld [hli], a
	dec b
	jp nz, MemFill
	ret


InitVars::
	; Init input variables
	xor a, a
	ld [wCurKeys], a
	ld [wNewKeys], a

	; Init player variables
	ld a, 16
	ld [wPlayerY], a

	ld a, 17
	ld [wEnemyY], a

	; Init ball variables
	ld a, 80
	ld [wBallCoordX], a
	ld [wBallCoordY], a
	ld a, 1
	ld [wBallVelX], a
	ld a, 1
	ld [wBallVelY], a

	ret

CheckWinLoss::
	ld a, [wBallCoordX]
	cp 0
	jp z, .reset
	cp 168
	jp z, .reset
	jp nc, .reset
	jp .exit
.reset:
	; rough fade to black
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJOFF
	ld [rLCDC], a
	
	call InitVars
	call PlaySoundEnd
	call StopSoundEnd
	
	; turn on sprites again
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
	ld [rLCDC], a
.exit:
	ret


; Loop until VBlank reached
; @param NO PARAM
VBlank::
	ld a, [rLY] 			; get value of current scanline
	cp 144					; check if scanline has reached bottom
	jp c, VBlank			; if not, loop
	ret

;--------------------------------;
; Macros to remove redundant code;
; while handling shadow oam		 ;
;--------------------------------;

MACRO m_left_paddle_args_load
	ld [hli], a
	ld a, 8
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
ENDM

MACRO m_right_paddle_args_load
	ld [hli], a
	ld a, 160
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
ENDM

; Update Shadow OAM with necessary sprites
; 3 done, 4 more to go
; @param None
UpdateSOam::

	; Load Shadow OAM
	ld hl, wShadowOam
	
	; Left Paddle

	; Top left
	ld a, [wPlayerY]
	m_left_paddle_args_load

	; Middle left
	ld a, [wPlayerY]
	add a, 8
	m_left_paddle_args_load

	; Right Paddle

	; Top right
	ld a, [wEnemyY]
	m_right_paddle_args_load

	; middle right
	ld a, [wEnemyY]
	add a, 8
	m_right_paddle_args_load

	; Ball Sprite
	ld a, [wBallCoordY]
	ld [hli], a
	ld a, [wBallCoordX]
	ld [hli], a
	ld a, 1
	ld [hli], a
	xor a
	ld [hli], a

	ret