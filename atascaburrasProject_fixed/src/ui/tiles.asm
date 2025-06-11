SECTION "Tiles", ROM0

; Make tile graphics accessible from other modules
EXPORT Tiles8p8
EXPORT TilesEnd

; Tiles8p8: 8 tiles con patrones visibles
Tiles8p8:
; Tile 0 - blanco
DB $00,$00,$00,$00,$00,$00,$00,$00
; Tile 1 - negro
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
; Tile 2 - línea horizontal
DB $FF,$00,$00,$00,$00,$00,$00,$FF
; Tile 3 - línea vertical
DB $81,$81,$81,$81,$81,$81,$81,$81
; Tile 4 - checker
DB $AA,$55,$AA,$55,$AA,$55,$AA,$55
; Tile 5 - marco
DB $FF,$81,$81,$81,$81,$81,$81,$FF
; Tile 6 - diagonal
DB $80,$40,$20,$10,$08,$04,$02,$01
; Tile 7 - invertido checker
DB $55,$AA,$55,$AA,$55,$AA,$55,$AA

TilesEnd:

; MetatilesIndex: 6 metatiles que combinan los tiles anteriores
MetatilesIndex::
; Metatile 0 - negro sólido
DB $01,$01,$01,$01