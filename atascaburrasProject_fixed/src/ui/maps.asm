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

; ----- Map 1 -----
; Basic maze using horizontal bars to create a simple path.
; Player starts at (1,1) and must reach the exit in the lower-right.
Map1:
    ROW_WALLS        ; top boundary
    ROW_EMPTY        ; starting area
    ROW_BAR_RIGHT
    ROW_BAR_LEFT
    ROW_BAR_RIGHT
    ROW_BAR_LEFT
    ROW_BAR_RIGHT
    ROW_BAR_LEFT
    ROW_BAR_RIGHT
    ROW_BAR_LEFT
    ROW_BAR_RIGHT
    ROW_BAR_LEFT
    ROW_BAR_RIGHT
    ROW_BAR_LEFT
    ROW_BAR_RIGHT
    ROW_BAR_LEFT
    ROW_EMPTY
    ROW_EXIT_CORNER  ; bottom row with exit on the right
