SECTION "GameSystem", ROM0

; Access state variables and map data
IMPORT MapIndex
IMPORT PlayerX
IMPORT PlayerY
IMPORT CurrentMapPtr
IMPORT Map1

InitGameSystem::
    ; initialize game-related variables
    ; Set the starting map and player position
    xor a
    ld [MapIndex], a
    ld [PlayerX], a
    ld [PlayerY], a
    ld hl, Map1
    ld [CurrentMapPtr], hl
    ret

UpdateGameSystem::
    ; update game state each frame
    ret