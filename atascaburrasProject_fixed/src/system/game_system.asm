SECTION "GameSystem", ROM0

; Access state variables and map data
IMPORT MapIndex
IMPORT PlayerX
IMPORT PlayerY
IMPORT CurrentMapPtr
IMPORT PlayerPrevX
IMPORT PlayerPrevY
IMPORT Map1

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
    dec a
    ld [hl], a

.check_right:
    ; Move right if pressed (bit cleared)
    bit 0, b
    jr nz, .done
    ld hl, PlayerX
    ld a, [hl]
    cp MAP_WIDTH-2
    jr z, .done
    inc a
    ld [hl], a

.done:
    ret
