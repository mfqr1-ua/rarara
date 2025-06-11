SECTION "Maps", ROM0

; Export first map so the renderer can load it
EXPORT Map1

; Helper macros for rows
MACRO ROW_WALLS
REPT 20
    DB MT_WALL
ENDR
ENDM

MACRO ROW_EMPTY
    DB MT_WALL
REPT 18
    DB MT_FLOOR
ENDR
    DB MT_WALL
ENDM

MACRO ROW_EXIT
    DB MT_WALL
REPT 17
    DB MT_FLOOR
ENDR
    DB MT_EXIT
    DB MT_WALL
ENDM

; ----- Map 1 -----