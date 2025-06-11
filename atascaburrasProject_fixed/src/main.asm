INCLUDE "src/utils/constants.asm"
INCLUDE "src/utils/memory.asm"
; Functions provided by other modules
IMPORT InitRender
IMPORT RenderFrame
IMPORT InitGameSystem
IMPORT UpdateGameSystem
INCLUDE "src/ui/tiles.asm"
INCLUDE "src/ui/maps.asm"

SECTION "Main", ROM0
Start:
    call InitRender
    call InitGameSystem

.loop:
    call UpdateGameSystem
    call RenderFrame
    jp .loop
