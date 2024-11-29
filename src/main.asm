INCLUDE "include/hardware.inc"


; Header
SECTION "Header", ROM0[$100]

	jp Init							; Skip Header
	ds $150 - @, 0					; Reserve space for header


; Entry Part
SECTION "Entry", ROM0

; Entry of program
Init:
	call CopyDMARoutine				; Copy the DMA routine from ROM to HRAM

	ld sp, $E000 					; Load stack pointer to just after end of WRAM

	; Check if we are in vertical blank or not
	call VBlank

	; Turn off LCD
	ld a, LCDCF_OFF
	ld [rLCDC], a

	; Copy sprite data
	ld de, pSprite1
	ld hl, _VRAM
	ld bc, pSprite1.end - pSprite1
	call MemCpy

	ld de, pSprite2
	ld hl, _VRAM + $10
	ld bc, pSprite2.end - pSprite2
	call MemCpy

	ld de, pSprite3
	ld hl, _VRAM + $20
	ld bc, pSprite3.end - pSprite3
	call MemCpy

	; Clear OAM memory
	ld a, 0							; Fill with 0
	ld b, 160 						; From _OAMRAM to _OAMRAM + 160
	ld hl, _OAMRAM 					; Destination, from _OAMRAM
	call MemFill

	; Clear OAM memory
	ld a, 0							; Fill with 0
	ld b, 160 						; From _OAMRAM to _OAMRAM + 160
	ld hl, $C000 					; Destination, from _OAMRAM
	call MemFill

	; Turn on LCD
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
	ld [rLCDC], a

	; Load pallete into background and objects
	ld a, %11100100
	ld [rBGP], a
	ld [rOBP0], a

	jp GameLoop							; Gotta do this cause graphics are placed
										; right after this section


; Main Code
SECTION "Main", ROM0

; Main function
GameLoop:

	; Reset hOAMIndex
	ld a, 0
	ld [hOAMIndex], a

	; push everything to shadow OAM

	; Top left paddle
	ld de, paddleLeftMetaSprite.s1
	call CpyMSprites

	; Middle left paddle
	ld de, paddleLeftMetaSprite.s2
	call CpyMSprites

	; Bottom left paddle
	ld de, paddleLeftMetaSprite.s3
	call CpyMSprites

	; Top right paddle
	ld de, paddleRightMetaSprite.s1
	call CpyMSprites

	; Middle right paddle
	ld de, paddleRightMetaSprite.s2
	call CpyMSprites

	; Bottom right paddle
	ld de, paddleRightMetaSprite.s3
	call CpyMSprites

	call VBlank

	; Direct memory access transfer shadow OAM to hard OAM
	ld a, HIGH(wShadowOam)
	call hOAMDMA

	jp GameLoop 						; loop back to main (no halt)
