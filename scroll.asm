
scroll_shift_left: ;ZP_PTR_1 set to first pixel of line, x to length of line (1 indexed)
  clc
  ldy #0
  lda (ZP_PTR_1),y
  rol ;load the initial bit into the carry
  txa
  dec
  tay ;load y with length -1
  @loop:
    lda (ZP_PTR_1),y
    rol
    sta (ZP_PTR_1),y
    dey
    dex
    bne @loop
  rts

scroll_4bpp_pixel_line_left: ;ZP_PTR_2 equals line length
  ldy #4
  @loop:
    phy
    ldx ZP_PTR_2
    jsr scroll_shift_left
    ply
    dey
    bne @loop
  rts

scroll_4bpp_tile_left:
  lda #0 ;initalise a and y
  ldy #0
  @loop:
    pha ;push to stack so a and y can be used for the line scroll loop
    phy
    jsr scroll_4bpp_pixel_line_left
    ply
    pla
    clc
    adc #8
    add_a_to_16_value ZP_PTR_1 ;macro adds a to a 16 value
    adc #8
    add_a_to_16_value ZP_PTR_2                                  ;in this case the pixel line address (we want to jump 8 bytes each loop)
    iny
    cpy #16 ; finish after 16 rows.
    bne @loop
  rts
