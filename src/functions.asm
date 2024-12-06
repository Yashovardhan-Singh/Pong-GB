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

	; Bottom left
	ld a, [wPlayerY]
	add a, 16
	m_left_paddle_args_load

	; Right Paddle

	; Top right
	ld a, 17
	m_right_paddle_args_load

	; middle right
	ld a, 25
	m_right_paddle_args_load

	; bottom right
	ld a, 33
	m_right_paddle_args_load

	; Ball Sprite
	ld a, 80
	ld [hli], a
	ld [hli], a
	ld a, 1
	ld [hli], a
	xor a
	ld [hli], a

	ret