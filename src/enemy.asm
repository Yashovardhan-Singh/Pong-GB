SECTION "Enemy", WRAM0

wEnemyY:: db

SECTION "Enemy Routines", ROM0

UpdateEnemy::
    ld a, [wBallCoordY]
    ld [wEnemyY], a
    ret