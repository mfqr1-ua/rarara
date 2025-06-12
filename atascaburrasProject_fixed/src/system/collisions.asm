INCLUDE "src/utils/constants.asm"

SECTION "Collision", ROM0

EXPORT GetTileAt
EXPORT IsWalkable

;--------------------------------------
; Returns tile at coordinates B = x, C = y in A
; Uses: HL, DE
GetTileAt:
    push hl
    push de
    ; DE = y * 4
    ld h, 0
    ld l, c
    sla l
    rl h
    sla l
    rl h
    ld d, h
    ld e, l
    ; HL = y * 16
    ld h, 0
    ld l, c
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    add hl, de              ; HL = y*20
    ; HL += x
    ld d, 0
    ld e, b
    add hl, de
    ; Add map base pointer
    ld a, [CurrentMapPtr]
    ld e, a
    ld a, [CurrentMapPtr+1]
    ld d, a
    add hl, de
    ld a, [hl]
    pop de
    pop hl
    ret

;--------------------------------------
; Checks if tile at B = x, C = y is walkable
; Returns A = 1 if walkable, 0 otherwise
; Uses: HL, DE
IsWalkable:
    call GetTileAt
    cp MT_WALL
    jr z, .blocked
    ld a, 1
    ret
.blocked:
    xor a
    ret
