; Game state variables
SECTION "State", WRAM0

; Expose state variables to other modules
EXPORT MapIndex
EXPORT PlayerX
EXPORT PlayerY
EXPORT CurrentMapPtr
EXPORT PlayerPrevX
EXPORT PlayerPrevY
EXPORT GameOver
EXPORT MoveCooldown
EXPORT CurrentNoteIndex
EXPORT NoteTimer
EXPORT Enemy1X
EXPORT Enemy1Y
EXPORT Enemy2X
EXPORT Enemy2Y
EXPORT Enemy3X
EXPORT Enemy3Y

; Variables stored in WRAM cannot contain initialised data.
; Reserve the required space and initialise them at runtime instead.
MapIndex:      ds 1
PlayerX:       ds 1
PlayerY:       ds 1
CurrentMapPtr: ds 2
PlayerPrevX:   ds 1
PlayerPrevY:   ds 1
GameOver:      ds 1
MoveCooldown:  ds 1
CurrentNoteIndex: ds 1
NoteTimer:  ds 1
Enemy1X:     ds 1
Enemy1Y:     ds 1
Enemy2X:     ds 1
Enemy2Y:     ds 1
Enemy3X:     ds 1
Enemy3Y:     ds 1
