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
