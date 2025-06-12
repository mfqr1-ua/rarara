SECTION "GameSystem", ROM0

; Access state variables and map data
EXPORT MapIndex
EXPORT PlayerX
EXPORT PlayerY
EXPORT CurrentMapPtr
EXPORT PlayerPrevX
EXPORT PlayerPrevY
EXPORT Map1

INCLUDE "src/utils/constants.asm"

InitGameSystem::
    xor a
    ld [MapIndex], a           ; MapIndex ← 0
    ld a, 1
    ld [PlayerX], a            ; PlayerX   ← 1 (start inside map)
    ld [PlayerPrevX], a        ; initial previous position
    ld a, 1
    ld [PlayerY], a            ; PlayerY   ← 1
    ld [PlayerPrevY], a

    ld hl, Map1                ; HL ← dirección de Map1

    ld a, l                    ; A ← byte bajo de HL
    ld [CurrentMapPtr], a      ; almacena L en CurrentMapPtr
    ld a, h                    ; A ← byte alto de HL
    ld [CurrentMapPtr+1], a    ; almacena H en CurrentMapPtr+1

    ret

UpdateGameSystem::
    ; Save current position
    ld a, [PlayerX]
    ld [PlayerPrevX], a
    ld a, [PlayerY]
    ld [PlayerPrevY], a

    ; Read directional input
    ld a, JOY_SELECT_DPAD
    ld [rJOYP], a
    ld a, [rJOYP]
    ld b, a                     ; Guarda el valor de entrada para pruebas

    ; Move left if pressed (bit cleared)
    bit 1, b
    jr nz, .check_right
    ld hl, PlayerX
    ld a, [hl]
    cp 1
    jr z, .check_right
    dec a                      ; candidate X
    ld d, a
    ld a, [PlayerY]
    ld e, a                    ; D = newX, E = current Y
    push bc                    ; preserve input bits
    ld b, d
    ld c, e
    call GetTileAt
    pop bc
    cp MT_WALL
    jr z, .check_right         ; blocked by wall
    ld a, d
    ld [hl], a

.check_right:
    ; Move right if pressed (bit cleared)
    bit 0, b
    jr nz, .check_up
    ld hl, PlayerX
    ld a, [hl]
    cp MAP_WIDTH-2
    jr z, .check_up
    inc a                      ; candidate X
    ld d, a
    ld a, [PlayerY]
    ld e, a
    push bc
    ld b, d
    ld c, e
    call GetTileAt
    pop bc
    cp MT_WALL
    jr z, .check_up
    ld a, d
    ld [hl], a

.check_up:
    ; Move up if pressed (bit cleared)
    bit 2, b
    jr nz, .check_down
    ld hl, PlayerY
    ld a, [hl]
    cp 1
    jr z, .check_down
    dec a                      ; candidate Y
    ld e, a
    ld a, [PlayerX]
    ld d, a
    push bc
    ld b, d
    ld c, e
    call GetTileAt
    pop bc
    cp MT_WALL
    jr z, .check_down
    ld a, e
    ld [hl], a

.check_down:
    ; Move down if pressed (bit cleared)
    bit 3, b
    jr nz, .done
    ld hl, PlayerY
    ld a, [hl]
    cp MAP_HEIGHT-2
    jr z, .done
    inc a                      ; candidate Y
    ld e, a
    ld a, [PlayerX]
    ld d, a
    push bc
    ld b, d
    ld c, e
    call GetTileAt
    pop bc
    cp MT_WALL
    jr z, .done
    ld a, e
    ld [hl], a

.done:
    ret

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
