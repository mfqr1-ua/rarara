INCLUDE "src/utils/constants.asm"
INCLUDE "src/utils/memory.asm"

INCLUDE "src/ui/tiles.asm"
INCLUDE "src/ui/maps.asm"

SECTION "Main", ROM0
Start::
    call InitGameSystem
    call InitRender

MainLoop:
    call UpdateGameSystem
    ld a, [GameOver]
    or a
    jr nz, Win
    call RenderFrame
    jp MainLoop

Win:
    call DisplayWinMessage
End:
    jr End ; halt on game completion
