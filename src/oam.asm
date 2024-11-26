INCLUDE "include/hardware.inc"

SECTION "OAM DMA routine", ROM0

CopyDMARoutine::
	ld hl, DMARoutine
	ld b, DMARoutine.end - DMARoutine
	ld c, LOW(hOAMDMA)
.copy
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, .copy
	ret

DMARoutine:
	ldh [rDMA], a
	ld a, 40
.wait
	dec a
	jr nz, .wait
	ret
.end


SECTION "OAM DMA", HRAM

hOAMDMA::
	ds DMARoutine.end - DMARoutine
