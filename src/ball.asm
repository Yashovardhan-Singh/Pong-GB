INCLUDE "include/hardware.inc"

SECTION "ball", WRAM0

wBallCoordX:: db
wBallCoordY:: db
wBallVelY:: db                  ; 0: Stopped, 1: single speed (+), 2: double speed (+),
                                ; 3: single speed (-), 4: double speed (-)
wBallVelX:: db


SECTION "ball routines", ROM0

; TODO: update the ball? Maybe?
UpdateBall::
    call SetBallVelocityX
    call SetBallVelocityY
    call SetBallPosX
    call SetBallPosY
.end:
    ret


SetBallPosY::
    ld a, [wBallVelY]
    
    cp a, 0
    ret z

    cp a, 1
    jp z, .IncY

    cp a, 3
    jp z, .DecY

.IncY:
    ld a, [wBallCoordY]
    inc a
    ld [wBallCoordY], a
    ret
.DecY:
    ld a, [wBallCoordY]
    dec a
    ld [wBallCoordY], a
    ret

SetBallPosX::
    ld a, [wBallVelX]
    
    cp a, 0
    ret z

    cp a, 1
    jp z, .IncX

    cp a, 3
    jp z, .DecX

.IncX:
    ld a, [wBallCoordX]
    inc a
    ld [wBallCoordX], a
    ret
.DecX:
    ld a, [wBallCoordX]
    dec a
    ld [wBallCoordX], a
    ret


; Routine for setting the ball velocity
SetBallVelocityY::
    ld a, [wBallCoordY]
    cp a, 15
    jp z, .PositiveY
    cp a, 153                   ; (144 + 16 - 7)
    jp z, .NegativeY
    ret
.PositiveY:
    ld a, 1
    ld [wBallVelY], a
    ret
.NegativeY:
    ld a, 3
    ld [wBallVelY], a
    ret

SetBallVelocityX::
    ld a, [wBallCoordX]
    cp a, 7                         ; (8 - 1)
    jp z, .PositiveX
    cp a, 161                       ; (160 + 8 - 7)
    jp z, .NegativeX
    ret
.PositiveX:
    ld a, 1
    ld [wBallVelX], a
    ret
.NegativeX:
    ld a, 3
    ld [wBallVelX], a
    ret