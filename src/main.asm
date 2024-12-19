INCLUDE "include/hardware.inc"


; Header
SECTION "Header", ROM0[$100]

	jp Init							; Skip Header, Declare Entry
	ds $150 - @, 0					; Reserve space for header


; Entry Part
SECTION "Entry", ROM0

; Entry of program
Init:
	call CopyDMARoutine				; Copy the DMA routine from ROM to HRAM

	ld sp, $E000 					; Load stack pointer to just after end of WRAM

	call InitSound

	; Check if we are in vertical blank or not
	call VBlank

	; Turn off LCD
	ld a, LCDCF_OFF
	ld [rLCDC], a

	; Copy paddle sprite data
	ld de, pSprite
	ld hl, _VRAM
	ld bc, pSprite.end - pSprite
	call MemCpy

	; Copy ball sprite data
	ld de, bSprite
	ld hl, _VRAM + $10
	ld bc, bSprite.end - bSprite
	call MemCpy

	; Clear OAM memory
	xor a							; Fill with 0
	ld b, 160 						; From _OAMRAM to _OAMRAM + 160
	ld hl, _OAMRAM 					; Destination, from _OAMRAM
	call MemFill

	; Clear Shadow OAM memory
	ld b, 160
	ld hl, wShadowOam 				; Destination, from Shadow OAM
	call MemFill

	call InitVars

	; Turn on LCD
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
	ld [rLCDC], a

	; Load pallete into background and objects
	ld a, %00100111
	ld [rBGP], a
	ld [rOBP0], a

	jp GameLoop


SECTION "Main", ROM0

; Main function
GameLoop:

	call RNGUpdate

	call UpdateKeys						; Update input
	call CheckUp						; Check for up
	call CheckDown						; Check for down
	
	call UpdateBall						; Update Ball
	call UpdateEnemy
	call CheckWinLoss
	
	call UpdateSOam						; Update Shadow OAM
	call VBlank							; Start checking for VBlank
	; Direct memory access transfer shadow OAM to hard OAM
	ld a, HIGH(wShadowOam)
	call hOAMDMA

	jp GameLoop 						; loop back to main (no halt)
