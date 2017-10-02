; MSU-1
; Kyle Swanson <k@ylo.ph>
;
; MSU-1 example

.include "libSFX.i"

init_with_MSU:
        RW_push set:a8i16

        lda     #$FF
        sta     MSU_VOLUME
        ldx     #$0001
        stx     MSU_TRACK
        lda     #$03
        sta     MSU_CONTROL

        CGRAM_setcolor_rgb 0, 0,255,0

        RW_pull
        rts

init_without_MSU:
        CGRAM_setcolor_rgb 0, 255,0,0
        rts

Main:
        ;Transfer and execute SMP code
        SMP_exec SMP_RAM, SMP, sizeof_SMP, SMP_RAM

        ;Detect MSU-1, fire a callback
        MSU_detect init_with_MSU, init_without_MSU

        ;Turn on screen
        lda     #inidisp(ON, DISP_BRIGHTNESS_MAX)
        sta     SFX_inidisp
        VBL_on

:       wai
        ldx     z:SFX_joy1trig
        cpx     #$00
        beq     :-
@l:     cpx     #JOY_L
        bne     @r
        ldy     #$0001
        jsr     ChangeTrack
@r:     cpx     #JOY_R
        bne     @end
        ldy     #$0002
        jsr     ChangeTrack
@end:   bra     :-

ChangeTrack:
        sty     MSU_TRACK
        lda     #$03
        sta     MSU_CONTROL
        rts

.segment "RODATA"
incbin  SMP,  "SMP.bin"
