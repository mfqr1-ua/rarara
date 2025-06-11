; Game state variables
SECTION "State", WRAM0

; Expose state variables to other modules
EXPORT MapIndex
EXPORT PlayerX
EXPORT PlayerY
EXPORT CurrentMapPtr

MapIndex:      db
PlayerX:       db
PlayerY:       db
CurrentMapPtr: dw