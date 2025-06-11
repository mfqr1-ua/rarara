; Game state variables
SECTION "State", WRAM0

; Expose state variables to other modules
EXPORT MapIndex
EXPORT PlayerX
EXPORT PlayerY
EXPORT CurrentMapPtr

MapIndex:      db 0
PlayerX:       db 0
PlayerY:       db 0
CurrentMapPtr: dw 0
