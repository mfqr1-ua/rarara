INCLUDE "src/utils/constants.asm"

SECTION "AudioSystem", ROM0

EXPORT InitAudioSystem
EXPORT UpdateAudioSystem
EXPORT StartWinMusic

; Internal routine to play the current note
PlayCurrentNote:
    ld a, [CurrentNoteIndex]
    ld c, a                ; c = index
    sla a                  ; a = index * 2
    add a, c               ; a = index * 3
    ld e, a
    ld d, 0
    ld a, [CurrentSequencePtr]
    ld l, a
    ld a, [CurrentSequencePtr+1]
    ld h, a
    add hl, de             ; HL points to entry
    ld a, [hl+]
    ld [rNR23], a          ; frequency low
    ld a, [hl+]
    or $80                 ; trigger with freq high
    ld [rNR24], a
    ld a, [hl]
    ld [NoteTimer], a      ; set duration
    ret

;--------------------------------------
; Initialise sound hardware and first note
InitAudioSystem::
    ld a, $80
    ld [rNR52], a          ; enable sound
    ld a, $77
    ld [rNR50], a          ; max volume
    ld a, $FF
    ld [rNR51], a          ; route all channels

    ld a, %01000000        ; 50% duty, length=0
    ld [rNR21], a
    ld a, $F0              ; constant volume envelope
    ld [rNR22], a

    xor a
    ld [CurrentNoteIndex], a
    ld [NoteTimer], a
    ld hl, NoteSequence
    ld a, l
    ld [CurrentSequencePtr], a
    ld a, h
    ld [CurrentSequencePtr+1], a
    ld a, NumNotes
    ld [CurrentNumNotes], a
    call PlayCurrentNote
    ret

;--------------------------------------
; Updates music, progressing notes when timer expires
UpdateAudioSystem::
    ld hl, NoteTimer
    ld a, [hl]
    or a
    jr z, .next
    dec [hl]
    ret
.next:
    ld hl, CurrentNoteIndex
    ld a, [hl]
    inc a
    ld b, a
    ld a, [CurrentNumNotes]
    cp b
    jr c, .wrap
    ld a, b
    jr .store
.wrap:
    xor a
.store:
    ld [hl], a
    call PlayCurrentNote
    ret

StartWinMusic:
    ld hl, WinSequence
    ld a, l
    ld [CurrentSequencePtr], a
    ld a, h
    ld [CurrentSequencePtr+1], a
    ld a, NumWinNotes
    ld [CurrentNumNotes], a
    xor a
    ld [CurrentNoteIndex], a
    ld [NoteTimer], a
    call PlayCurrentNote
    ret

; Note data: frequency low byte, high byte, duration frames
NoteSequence:
    db $06, $07, 16  ; C5
    db $39, $07, 16  ; E5
    db $59, $07, 16  ; G5
    db $83, $07, 16  ; C6
    db $59, $07, 16  ; G5
    db $39, $07, 16  ; E5
    db $06, $07, 16  ; C5
    db $59, $07, 16  ; G5
DEF NumNotes = 8

WinSequence:
    db $83, $07, 16  ; C6
    db $59, $07, 16  ; G5
    db $83, $07, 32  ; C6 sustained
DEF NumWinNotes = 3
