SECTION "Tiles", ROM0

EXPORT Tiles8p8
EXPORT TilesEnd

; Simple 8x8 tiles
Tiles8p8:
; Tile 0 - floor (blank)
    DB $00,$00,$00,$00,$00,$00,$00,$00
; Tile 1 - wall (border lines)
    DB $FF,$81,$81,$81,$81,$81,$81,$FF
; Tile 2 - exit symbol
    DB $3C,$42,$99,$A5,$A5,$99,$42,$3C
; Tile 3 - player icon (simple ball)
    DB $3C,$42,$81,$81,$81,$81,$42,$3C

TilesEnd:
