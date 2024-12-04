INCLUDE "include/hardware.inc"

SECTION "Input Variables", WRAM0

wCurKeys:: db
wNewKeys:: db


SECTION "Input Routines", ROM0

UpdateKeys::
    ld a, P1F_GET_BTN
    call .onenibble
    ld b, a
    
    ld a, P1F_GET_DPAD
    call .onenibble
    swap a
    xor a, b
    ld b, a

    ld a, P1F_GET_NONE
    ldh [rP1], a

    ld a, [wCurKeys]
    xor a, b
    and a, b
    ld [wNewKeys], a
    ld a, b
    ld [wCurKeys], a
    ret

.onenibble
    ldh [rP1], a
    call .knownret
    ldh a, [rP1]                    ; Ignore
    ldh a, [rP1]                    ; Ignore
    ldh a, [rP1]                    ; Read that counts
    or a, $F0                       ; Unpressed keys
.knownret
    ret


; Check every frame is Up on DPAD is pressed
; @param: None
CheckUp::
    ld a, [wCurKeys]
    and a, PADF_UP
    jp nz, .end
    call MoveUp
.end:
    ret

CheckDown::
    ld a, [wCurKeys]
    and a, PADF_DOWN
    jp nz, .end
    call MoveDown
.end:
    ret