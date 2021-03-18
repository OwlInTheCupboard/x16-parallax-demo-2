

scroll_4bpp_pixel_line_left:
  ldy #0
  @loop:
    clc
    lda test_sprite
    rol ;load the inital bit into the carry
    lda test_sprite + 7
    rol
    sta test_sprite + 7
    lda test_sprite + 6
    rol
    sta test_sprite + 6
    lda test_sprite + 5
    rol
    sta test_sprite + 5
    lda test_sprite + 4
    rol
    sta test_sprite + 4
    lda test_sprite + 3
    rol
    sta test_sprite + 3
    lda test_sprite + 2
    rol
    sta test_sprite + 2
    lda test_sprite + 1
    rol
    sta test_sprite + 1
    lda test_sprite
    rol
    sta test_sprite
    iny
    cpy #4 ;rol 5 times (4 bits plus the carry)
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
