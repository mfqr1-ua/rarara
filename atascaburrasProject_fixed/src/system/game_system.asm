SECTION "GameSystem", ROM0

; Access state variables and map data
IMPORT MapIndex
IMPORT PlayerX
IMPORT PlayerY
IMPORT CurrentMapPtr
IMPORT Map1

InitGameSystem::
    xor a
    ld [MapIndex], a
    ld [PlayerX], a
    ld [PlayerY], a
    ld hl, Map1
    ld [CurrentMapPtr], hl
    ret

UpdateGameSystem::
    ; placeholder for game logic
    ret
