INCLUDE "src/utils/constants.asm"
INCLUDE "src/utils/memory.asm"

INCLUDE "src/ui/tiles.asm"
INCLUDE "src/ui/maps.asm"

SECTION "Main", ROM0
Start::
    call InitRender
    call InitGameSystem

MainLoop:
    call UpdateGameSystem
    ld a, [GameOver]
    or a
    jr nz, End
    call RenderFrame
    jp MainLoop

End:
    jr End ; halt on game completion
