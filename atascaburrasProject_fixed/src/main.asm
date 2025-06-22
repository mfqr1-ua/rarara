INCLUDE "src/utils/constants.asm"

INCLUDE "src/ui/tiles.asm"
INCLUDE "src/ui/maps.asm"

SECTION "Main", ROM0
Start::
    call InitGameSystem
    call InitRender
    call InitAudioSystem

MainLoop:
    call UpdateGameSystem
    call UpdateAudioSystem
    ld a, [GameOver]
    or a
    jr nz, Win
    call RenderFrame
    jp MainLoop

Win:
    call StartWinState
WinLoop:
    call UpdateAudioSystem
    jr WinLoop

StartWinState:
    ld a, [WinStarted]
    or a
    ret nz
    call SetWinPalette
    call StartWinMusic
    ld a, 1
    ld [WinStarted], a
    ret
