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
; Tile 4 - letter Y
    DB $81,$42,$24,$18,$18,$18,$18,$18
; Tile 5 - letter O
    DB $3C,$42,$81,$81,$81,$81,$42,$3C
; Tile 6 - letter U
    DB $81,$81,$81,$81,$81,$81,$42,$3C
; Tile 7 - letter W
    DB $81,$81,$81,$91,$91,$91,$42,$24
; Tile 8 - letter I
    DB $FF,$18,$18,$18,$18,$18,$18,$FF
; Tile 9 - letter N
    DB $81,$C1,$A1,$91,$89,$85,$83,$81
; Tile 10 - enemy icon (X shape)
    DB $81,$42,$24,$18,$24,$42,$81,$00

TilesEnd:
