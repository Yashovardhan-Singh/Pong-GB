INCLUDE "include/hardware.inc"

SECTION "GRAPHICS", ROM0

; Paddle Sprite
pSprite:: INCBIN "assets/gen/p_sprite.2bpp"
.end::

; Ball Sprite
bSprite:: INCBIN "assets/gen/b_sprite.2bpp"
.end::