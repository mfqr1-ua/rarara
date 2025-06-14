SECTION "Maps", ROM0

EXPORT Map1

MACRO ROW_WALLS
    REPT MAP_WIDTH
        DB MT_WALL
    ENDR
ENDM

MACRO ROW_EMPTY
    DB MT_WALL
    REPT MAP_WIDTH - 2
        DB MT_FLOOR
    ENDR
    DB MT_WALL
ENDM

MACRO ROW_EXIT
    DB MT_WALL
    REPT MAP_WIDTH - 3
        DB MT_FLOOR
    ENDR
    DB MT_EXIT
    DB MT_WALL
ENDM

; Row with a horizontal wall leaving a gap on the left
MACRO ROW_BAR_LEFT
    DB MT_WALL
    DB MT_FLOOR
    REPT MAP_WIDTH - 3
        DB MT_WALL
    ENDR
    DB MT_WALL
ENDM

; Row with a horizontal wall leaving a gap on the right
MACRO ROW_BAR_RIGHT
    DB MT_WALL
    REPT MAP_WIDTH - 3
        DB MT_WALL
    ENDR
    DB MT_FLOOR
    DB MT_WALL
ENDM

; Bottom row with the exit in the bottom-right corner
MACRO ROW_EXIT_CORNER
    ; Bottom boundary with the exit in the bottom-right corner
    DB MT_WALL
    REPT MAP_WIDTH - 2
        DB MT_FLOOR
    ENDR
    DB MT_EXIT
ENDM

; Row with a vertical wall in the middle (column 10)
MACRO ROW_VBAR
    DB MT_WALL
    REPT 9
        DB MT_FLOOR
    ENDR
    DB MT_WALL
    REPT 8
        DB MT_FLOOR
    ENDR
    DB MT_WALL
ENDM

; Same as ROW_VBAR but the rightmost tile is floor
MACRO ROW_VBAR_RIGHT_GAP
    DB MT_WALL
    REPT 9
        DB MT_FLOOR
    ENDR
    DB MT_WALL
    REPT 8
        DB MT_FLOOR
    ENDR
    DB MT_FLOOR
ENDM

; Row like ROW_VBAR_RIGHT_GAP but with the exit one tile
; up-left from the bottom-right corner (column 18)
MACRO ROW_EXIT_UPLEFT
    DB MT_WALL
    REPT 9
        DB MT_FLOOR
    ENDR
    DB MT_WALL
    REPT 7
        DB MT_FLOOR
    ENDR
    DB MT_EXIT
    DB MT_FLOOR
ENDM

Map1:
    ROW_WALLS        ; fila 0: límite superior
    ROW_EMPTY        ; fila 1: zona de inicio

    ROW_VBAR         ; fila 2: muro vertical
    ROW_EMPTY        ; fila 3: CORREDOR LIBRE  ← antes ROW_BAR_RIGHT

    ROW_VBAR         ; fila 4: muro vertical
    ROW_BAR_LEFT     ; fila 5: muro con hueco a la izquierda
    ROW_VBAR         ; fila 6: muro vertical

    ROW_EMPTY        ; fila 7: GAP en la pared
    ROW_VBAR         ; fila 8: muro vertical
    ROW_EMPTY        ; fila 9: CORREDOR LIBRE  ← antes ROW_BAR_RIGHT

    ROW_VBAR         ; fila 10
    ROW_BAR_LEFT     ; fila 11
    ROW_VBAR         ; fila 12

    ROW_VBAR         ; fila 13: muro vertical
    ROW_EMPTY        ; fila 14: CORREDOR LIBRE  ← antes ROW_VBAR

    ROW_VBAR         ; fila 15: muro vertical
    ROW_EXIT_UPLEFT  ; fila 16: salida antes de la esquina
    ROW_VBAR_RIGHT_GAP ; fila 17: sin salida

EXPORT Map2

Map2:
    ROW_WALLS
    ROW_BAR_LEFT         ; apertura en la izquierda
    ROW_EMPTY            ; permite cruzar horizontalmente
    ROW_EMPTY            ; pasillo sin muro
    ROW_VBAR
    ROW_BAR_RIGHT        ; hueco por la derecha
    ROW_VBAR
    ROW_EMPTY
    ROW_VBAR
    ROW_BAR_LEFT
    ROW_VBAR
    ROW_BAR_LEFT         ; mantiene el corredor
    ROW_EMPTY            ; cruce central
    ROW_BAR_RIGHT        ; obliga a ir a la derecha
    ROW_VBAR
    ROW_EMPTY
    ROW_VBAR_RIGHT_GAP
    ROW_EXIT_CORNER

EXPORT Map3

Map3:
    ROW_WALLS
    ROW_BAR_RIGHT
    ROW_EMPTY
    ROW_BAR_LEFT
    ROW_EMPTY
    ROW_VBAR
    ROW_EMPTY
    ROW_VBAR_RIGHT_GAP
    ROW_EMPTY
    ROW_VBAR
    ROW_BAR_RIGHT
    ROW_EMPTY
    ROW_VBAR
    ROW_BAR_LEFT
    ROW_EMPTY
    ROW_VBAR_RIGHT_GAP
    ROW_EMPTY
    ROW_EXIT_CORNER

EXPORT Map4

Map4:
    ROW_WALLS
    ROW_EMPTY
    ROW_VBAR
    ROW_BAR_RIGHT
    ROW_VBAR
    ROW_EMPTY
    ROW_VBAR_RIGHT_GAP
    ROW_EMPTY
    ROW_BAR_LEFT
    ROW_VBAR
    ROW_EMPTY
    ROW_BAR_RIGHT
    ROW_VBAR
    ROW_EMPTY
    ROW_VBAR_RIGHT_GAP
    ROW_EMPTY
    ROW_VBAR
    ROW_EXIT_CORNER

EXPORT Map5

Map5:
    ROW_WALLS
    ROW_EMPTY
    ROW_VBAR_RIGHT_GAP
    ROW_EMPTY
    ROW_VBAR
    ROW_BAR_RIGHT
    ROW_VBAR
    ROW_BAR_RIGHT
    ROW_VBAR
    ROW_EMPTY
    ROW_VBAR_RIGHT_GAP
    ROW_EMPTY
    ROW_VBAR_RIGHT_GAP
    ROW_EMPTY
    ROW_VBAR
    ROW_EMPTY
    ROW_VBAR_RIGHT_GAP
    ROW_EXIT_CORNER
