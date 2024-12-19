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
	ld a, 0							; Fill with 0
	ld b, 160 						; From _OAMRAM to _OAMRAM + 160
	ld hl, _OAMRAM 					; Destination, from _OAMRAM
	call MemFill

	; Clear Shadow OAM memory
	ld b, 160
	ld hl, wShadowOam 				; Destination, from Shadow OAM
	call MemFill

	; Init variables
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
	ld [wBallVelY], a

	; Init RNG Variable
	ld a, 0
	ld [wRNGState], a
	ld [wRNGIndex], a

	; Turn on LCD
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
	ld [rLCDC], a

	; Load pallete into background and objects
	ld a, %00100111
	ld [rBGP], a
	ld [rOBP0], a

	jp GameLoop							; Gotta do this cause graphics are placed
										; right after this section


; Main Code
SECTION "Main", ROM0

; Main function
GameLoop:

	call RNGUpdate

	call UpdateKeys						; Update input
	
	call CheckUp						; Check for up
	call CheckDown						; Check for down
	
	call UpdateBall						; Update Ball

	call UpdateEnemy
	
	call UpdateSOam						; Update Shadow OAM

	call VBlank							; Start checking for VBlank

	; Direct memory access transfer shadow OAM to hard OAM
	ld a, HIGH(wShadowOam)
	call hOAMDMA

	jp GameLoop 						; loop back to main (no halt)
