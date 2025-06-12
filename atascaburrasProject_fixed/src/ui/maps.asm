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
    ROW_EXIT_CORNER  ; fila 16: salida en la esquina inferior derecha
