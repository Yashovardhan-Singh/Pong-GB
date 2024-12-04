INCLUDE "include/hardware.inc"

SECTION "OAM DMA routine", ROM0

; Routine to copy the code to HRAM
CopyDMARoutine::
	ld hl, DMARoutine					; Get the mem addr
	ld b, DMARoutine.end - DMARoutine	; Size of snippet
	ld c, LOW(hOAMDMA)					; low byte of destination
.copy
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, .copy
	ret

DMARoutine:
	ldh [rDMA], a						; starts DMA if anything written
	ld a, 40							; delay
.wait
	dec a
	jr nz, .wait
	ret
.end


SECTION "OAM DMA", HRAM[$FF80]

hOAMDMA::
	ds DMARoutine.end - DMARoutine		; reserve location for code snippet



SECTION "Shadow OAM", WRAM0[$C000], ALIGN[8]
wShadowOam::
	ds 160								; reserve space for shadow OAM
