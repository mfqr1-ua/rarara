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
Map1:
    ; Top border
    ROW_WALLS      ; row 0
    ; Player starts on row 1, column 1
    ROW_EMPTY      ; row 1
    ROW_BAR_RIGHT  ; row 2
    ROW_EMPTY      ; row 3
    ROW_BAR_LEFT   ; row 4
    ROW_EMPTY      ; row 5
    ROW_BAR_RIGHT  ; row 6
    ROW_EMPTY      ; row 7
    ROW_BAR_LEFT   ; row 8
    ROW_EMPTY      ; row 9
    ROW_BAR_RIGHT  ; row 10
    ROW_EMPTY      ; row 11
    ROW_BAR_LEFT   ; row 12
    ROW_EMPTY      ; row 13
    ROW_BAR_RIGHT  ; row 14
    ROW_EMPTY      ; row 15
    ROW_BAR_LEFT   ; row 16
    ; Bottom row with the exit in the corner
    ROW_EXIT_CORNER ; row 17
