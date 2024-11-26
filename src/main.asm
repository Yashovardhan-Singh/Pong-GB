INCLUDE "include/hardware.inc"


SECTION "Header", ROM0[$100]

	jp EntryPoint
	ds $150 - @, 0


SECTION "Entry", ROM0

EntryPoint:
	call CopyDMARoutine
	
WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank

	ld a, LCDCF_OFF
	ld [rLCDC], a

	ld a, 0
	ld b, 160
	ld hl, _OAMRAM
	call MemFill

	ld a, LCDCF_ON
	ld [rLCDC], a

	ld a, %00100111
	ld [rBGP], a


SECTION "Main", ROM0

Main:
	ld a, [rLY]
	cp 144
	jp nc, Main

WaitVBlank2:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank2

	jp Main
