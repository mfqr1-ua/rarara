SECTION "Collision", ROM0

INCLUDE "src/utils/constants.asm"
INCLUDE "src/utils/memory.asm"
; memory.asm switches to the WRAM0 section, so we must
; return to ROM0 for code after the include
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
    ld hl, CurrentMapPtr
    ld e, [hl]
    inc hl
    ld d, [hl]
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
