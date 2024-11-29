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


; Special Copy Function for metasprites
CpyMSprites::
	ld a, $00				; Store the lower part of shadow OAM
	ld hl, hOAMIndex		; load OAM index into hl
	adc a, [hl] 			; add how many sprites done to offset shadow OAM
	ld h, $c0 				; Store high byte of shadow OAM to h
	ld l, a					; store low byte with offset to l
	ld bc, 4 				; length of object, 4 properties
	call MemCpy 			; copy
	ld hl, hOAMIndex
	ld a, [hl]
	adc a, 4
	ld [hl], a 				; increment hl by 4
	ret

