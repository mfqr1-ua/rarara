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
EXPORT WinStarted
EXPORT CurrentSequencePtr
EXPORT CurrentNumNotes

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
WinStarted: ds 1
CurrentSequencePtr: ds 2
CurrentNumNotes: ds 1
