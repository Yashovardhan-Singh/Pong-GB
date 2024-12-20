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

    cp a, 2
    jp z, .DIncY

    cp a, 3
    jp z, .DecY

    cp a, 4
    jp z, .DDecY

    ret

.IncY:
    ld a, [wBallCoordY]
    inc a
    ld [wBallCoordY], a
    ret
.DIncY:
    ld a, [wBallCoordY]
    add a, 2
    ld [wBallCoordY], a
    ret
.DecY:
    ld a, [wBallCoordY]
    dec a
    ld [wBallCoordY], a
    ret
.DDecY:
    ld a, [wBallCoordY]
    sub a, 2
    ld [wBallCoordY], a
    ret

SetBallPosX::
    ld a, [wBallVelX]
    
    cp a, 0
    ret z

    cp a, 1
    jp z, .IncX

    cp a, 2
    jp z, .DIncX

    cp a, 3
    jp z, .DecX

    cp a, 4
    jp z, .DDecX

    ret

.IncX:
    ld a, [wBallCoordX]
    inc a
    ld [wBallCoordX], a
    ret
.DIncX:
    ld a, [wBallCoordX]
    add a, 2
    ld [wBallCoordX], a
    ret
.DecX:
    ld a, [wBallCoordX]
    dec a
    ld [wBallCoordX], a
    ret
.DDecX
    ld a, [wBallCoordX]
    dec a
    ld [wBallCoordX], a
    ret


; Routine for setting the ball velocity
SetBallVelocityY::
    ld a, [wBallCoordY]
    cp a, 15
    jp z, .PositiveY
    jp c, .PositiveY
    cp a, 153                   ; (144 + 16 - 7)
    jp z, .NegativeY
    jp nc, .NegativeY
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
    cp a, 15                         ; (16 - 1)
    jp z, .SecondPveCheck
    jp c, .SecondPveCheck
.FirstNveCheck
    cp a, 155                       ; (160 - 12 + 7)
    jp z, .SecondNveCheck
    jp nc, .SecondNveCheck
    jp .exit
.SecondPveCheck:
    ld a, [wPlayerY]
    ld b, a                         ; Player Top Left Point (Y)
    ld a, [wBallCoordY]
    cp a, b
    jp z, .ThirdPveCheck
    jp nc, .ThirdPveCheck
    jp .FirstNveCheck
.SecondNveCheck:
    ld a, [wEnemyY]
    ld b, a
    ld a, [wBallCoordY]
    cp a, b
    jp z, .ThirdNveCheck
    jp nc, .ThirdNveCheck
    jp .exit
.ThirdPveCheck:
    ld a, [wBallCoordY]
    ld b, a
    ld a, [wPlayerY]
    add a, 16
    cp a, b
    jp z, .PositiveX
    jp nc, .PositiveX
    jp .FirstNveCheck
.ThirdNveCheck:
    ld a, [wBallCoordY]
    ld b, a
    ld a, [wEnemyY]
    add a, 16
    cp a, b
    jp z, .NegativeX
    jp nc, .NegativeX
    jp .exit
.PositiveX:
    ld a, [wRNGState]
    and 1
    cp 0
    jp z, .Peven
    ld a, 2
    jp .write
.Peven:
    ld a, 1
    jp .write
.NegativeX:
    ld a, [wRNGState]
    and 1
    cp 0
    jp z, .Neven
    ld a, 4
    jp .write
.Neven:
    ld a, 3
.write:
    ld [wBallVelX], a
    call PlaySound
    call StopSound
    jp .exit
.exit:
    ret