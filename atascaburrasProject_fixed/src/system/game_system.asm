SECTION "GameSystem", ROM0

; Access state variables and map data
IMPORT MapIndex
IMPORT PlayerX
IMPORT PlayerY
IMPORT CurrentMapPtr
IMPORT Map1

INCLUDE "src/utils/constants.asm"

InitGameSystem::
    xor a
    ld [MapIndex], a
    ld [PlayerX], a
    ld [PlayerY], a
    ld hl, Map1
    ld [CurrentMapPtr], hl
    ret

UpdateGameSystem::
    ; Read directional input
    ld a, JOY_SELECT_DPAD
    ld [rJOYP], a
    ld a, [rJOYP]

    ; Move left if pressed (bit cleared)
    bit 1, a
    jr nz, .check_right
    ld hl, PlayerX
    ld a, [hl]
    dec a
    ld [hl], a

.check_right:
    ; Move right if pressed (bit cleared)
    bit 0, a
    jr nz, .done
    ld hl, PlayerX
    ld a, [hl]
    inc a
    ld [hl], a

.done:
    ret
