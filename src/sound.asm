INCLUDE "include/hardware.inc"

SECTION "Sound Routines", ROM0

InitSound::
	ld a, $80
	ldh [rNR52], a
	ld a, $77
	ldh [rNR51], a
	ld a, $F3
	ldh [rNR50], a
    ret


PlaySound::
	ld a, $80                ; Duty cycle 50%, sound ON
    ldh [rNR10], a      ; Write to NR10 (Channel 1 Sweep Register)
    ld a, $F0                ; Max volume, no envelope sweep
    ldh [rNR12], a        ; Write to NR12 (Channel 1 Envelope Register)
    ld a, $84                ; Set frequency low byte
    ldh [rNR13], a        ; Write to NR13 (Channel 1 Frequency Lo Byte)
    ld a, $87
    ldh [rNR14], a
    ret


StopSound::
    ld a, $FF
.loop:
    dec a
    cp 0
    jp nz, .loop
    xor a
    ldh [rNR10], a
    ldh [rNR12], a
    ldh [rNR13], a
    ldh [rNR14], a
    ret

PlaySoundEnd::
    ld a, $80                ; Duty cycle 50%, sound ON
    ldh [rNR21], a      ; Write to NR10 (Channel 1 Sweep Register)
    ld a, $F0                ; Max volume, no envelope sweep
    ldh [rNR22], a        ; Write to NR12 (Channel 1 Envelope Register)
    ld a, $84                ; Set frequency low byte
    ldh [rNR23], a        ; Write to NR13 (Channel 1 Frequency Lo Byte)
    ld a, $87
    ldh [rNR24], a
    ret

StopSoundEnd::
    ld bc, $FFFF
.loop:
    dec bc
    ld a, b
    or a
    jp nz, .loop
    xor a
    ldh [rNR21], a
    ldh [rNR22], a
    ldh [rNR23], a
    ldh [rNR24], a
    ret