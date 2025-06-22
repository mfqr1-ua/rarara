INCLUDE "src/utils/constants.asm"

INCLUDE "src/ui/tiles.asm"
INCLUDE "src/ui/maps.asm"

SECTION "Main", ROM0
Start::
    call InitGameSystem
    call InitAISystem
    call InitRender
    call InitAudioSystem
    ; Draw initial frame so the enemy is visible immediately
    call RenderFrame

MainLoop:
    call UpdateGameSystem
    call UpdateAISystem
    call UpdateAudioSystem
    ld a, [GameOver]
    or a
    jr nz, Win
    call RenderFrame
    jp MainLoop

Win:
    call SetWinPalette
WinLoop:
    call WaitVBlankStart
    call UpdateAudioSystem
    jr WinLoop
