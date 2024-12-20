SECTION "Enemy", WRAM0

wEnemyY:: db

SECTION "Enemy Routines", ROM0

UpdateEnemy::
    ld a, [wEnemyY]
    ld hl, wBallCoordY
    cp a, [hl]
    jp nc, .greater
    jp c, .less
    jp .end
.less:
    add a, 2
    cp a, 144                   ; I do not know how, but yes
    jp z, .end
    ld [wEnemyY], a
    jp .end
.greater:
    sub a, 2
    cp a, 16                   ; I do not know how, but yes
    jp z, .end
    ld [wEnemyY], a
    jp .end
.end:
    ret