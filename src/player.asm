SECTION "player variables", WRAM0

wPlayerY:: db


SECTION "player routines", ROM0

MoveUp::
    ld a, [wPlayerY]
    inc a
    cp a, 144                   ; I do not know how, but yes
    jp z, .end
    ld [wPlayerY], a
.end
    ret

MoveDown::
    ld a, [wPlayerY]
    dec a
    cp a, 16                    ; Prolly because a stores Y location
                                ; Which is normal, but screen space
                                ; is inverted ('_')
    jp z, .end
    ld [wPlayerY], a
.end
    ret