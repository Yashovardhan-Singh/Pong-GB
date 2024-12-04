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


; Update Shadow OAM with necessary sprites
; 3 done, 4 more to go
; @param None
UpdateSOam::

	; Load Shadow OAM
	ld hl, wShadowOam
	
	; Top left
	ld a, [wPlayerY]
	ld [hli], a
	ld a, 8
	ld [hli], a
	ld a, 0
	ld [hli], a
	ld [hli], a

	; Middle left
	ld a, [wPlayerY]
	add a, 8
	ld [hli], a
	ld a, 8
	ld [hli], a
	ld a, 0
	ld [hli], a
	ld [hli], a

	; Bottom left
	ld a, [wPlayerY]
	add a, 16
	ld [hli], a
	ld a, 8
	ld [hli], a
	ld a, 0
	ld [hli], a
	ld [hli], a

	ret