INCLUDE "include/hardware.inc"

SECTION "GRAPHICS", ROM0

; Top part
pSprite1:: INCBIN "assets/gen/test_sprite.2bpp"
.end::

; Middle part
pSprite2:: INCBIN "assets/gen/test_sprite2.2bpp"
.end::

; Bottom part
pSprite3:: INCBIN "assets/gen/test_sprite3.2bpp"
.end::


SECTION "SPRITES", ROM0


paddleLeftMetaSprite::
    .s1::    db 16,8,0,0                ; sprite 1
    .s2::    db 24,8,1,0                ; sprite 2
    .s3::    db 32,8,2,0                ; sprite 3

paddleRightMetaSprite::
    .s1::    db 16,160,0, OAMF_XFLIP    ; sprite 1, but X flipped
    .s2::    db 24,160,1, OAMF_XFLIP    ; sprite 2, but X flipped
    .s3::    db 32,160,2, OAMF_XFLIP    ; sprite 3, but X flipped