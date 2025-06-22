SECTION "render", ROM0

INCLUDE "src/utils/constants.asm"

; External resources from UI module
EXPORT Tiles8p8
EXPORT TilesEnd

; Routines de render
EXPORT InitRender
EXPORT RenderFrame
EXPORT DrawMap
EXPORT DisplayWinMessage

; -----------------------------------------------------------------------------
; Espera a VBlank
WaitVBlankStart::
    ld a, [$FF44]
    cp 144
    jr nz, WaitVBlankStart
    ret

; Apaga LCD
SwitchOffScreen::
    ld a, [$FF40]
    res 7, a
    ld [$FF40], a
    ret

; Enciende LCD
SwitchOnScreen::
    ld a, [$FF40]
    set 7, a
    ld [$FF40], a
    ret

; -----------------------------------------------------------------------------
; InitRender: carga tiles y dibuja mapa inicial completo
InitRender::
    call SwitchOffScreen

    ; Activar tile data a $8000
    ld a, [rLCDC]
    set 4, a
    ld [rLCDC], a

    ; Copiar banco de tiles Tiles8p8→TilesEnd a VRAM
    ld hl, Tiles8p8
    ld de, $8000
    ld bc, TilesEnd - Tiles8p8
CopyTiles::
    ld a, [hl+]
    ld [de], a
    inc de
    dec bc
    ld a, c
    or b
    jr nz, CopyTiles

    ; Dibujar fondo (tilemap) completo
    call DrawMap

    call SwitchOnScreen
    ret

; -----------------------------------------------------------------------------
; RenderFrame: actualiza sprite del jugador cada frame
RenderFrame::
    call WaitVBlankStart

    ; Restaurar tile de fondo en posición anterior
    ld a, [PlayerPrevY]
    ld l, a
    ld h, 0
    ; DE = y*4
    sla l
    rl h
    sla l
    rl h
    ld d, h
    ld e, l
    ; HL = y*16 (shift 4 veces)
    ld l, a
    ld h, 0
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    add hl, de            ; HL = y*20
    ; añadir x
    ld a, [PlayerPrevX]
    ld e, a
    ld d, 0
    add hl, de            ; offset
    ; sumar base de mapa
    ld a, [CurrentMapPtr]
    ld e, a
    ld a, [CurrentMapPtr+1]
    ld d, a
    add hl, de
    ; B = tile original
    ld b, [hl]
    ; escribirlo
    ld a, b
    ld [hl], a

    ; Dibujar jugador en posición actual
    ld a, [PlayerY]
    ld l, a
    ld h, 0
    ; HL = y*32 (shift 5 veces)
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    ; añadir x
    ld a, [PlayerX]
    ld e, a
    ld d, 0
    add hl, de
    ; sumar base tilemap
    ld de, $9800
    add hl, de
    ; colocar tile jugador
    ld a, MT_PLAYER
    ld [hl], a
    ret

; -----------------------------------------------------------------------------
; DrawMap: dibuja tilemap completo usando CurrentMapPtr
DrawMap::
    call WaitVBlankStart
    ld hl, $9800
    ; cargar puntero
    ld de, CurrentMapPtr
    ld a, [de]
    ld e, a
    inc de
    ld a, [de]
    ld d, a
    ld b, MAP_HEIGHT
RowLoop::
    ld c, MAP_WIDTH
ColLoop::
    ld a, [de]
    inc e
    ld [hl+], a
    dec c
    jr nz, ColLoop
    ld a, l
    add a, $20 - MAP_WIDTH
    ld l, a
    ld a, h
    adc a, 0
    ld h, a
    dec b
    jr nz, RowLoop
    ret

; -----------------------------------------------------------------------------
; WinMessage: cadena y longitud usando EQU
WinMessage:
    db TILE_Y, TILE_O, TILE_U, TILE_SPACE, TILE_W, TILE_I, TILE_N
WinMessageLen EQU . - WinMessage

; -----------------------------------------------------------------------------
; DisplayWinMessage: limpia fondo y escribe YOU WIN centrado
DisplayWinMessage::
    call WaitVBlankStart
    call SwitchOffScreen

    ; Limpiar todo el tilemap a TILE_SPACE
    ld hl, $9800
    ld bc, $0400        ; 32×32
    ld a, TILE_SPACE
ClearLoop::
    ld [hl+], a
    dec bc
    ld a, c
    or b
    jr nz, ClearLoop

    ; Escribir mensaje en row 9,col 6 (p.ej. $9926)
    ld hl, WinMessage
    ld de, $9926
    ld b, WinMessageLen
WriteChar::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, WriteChar

    call SwitchOnScreen
    ret
