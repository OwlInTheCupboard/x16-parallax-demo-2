pixel_line_addr: .addr 0

scroll_4bpp_pixel_line_left:
  ldx #8 ;16x16 tile at 4bpp is 8 bytes across
  ldy #0
  lda pixel_line_addr
  rol ;load the inital bit into the carry
  @loop:
    @line_loop:
      dex
      lda pixel_line_addr,x
      rol
      sta pixel_line_addr,x
      cpx #0
      bne @line_loop
    iny
    cpy #5 ;rol 5 times (4 bits plus the carry)
    bne @loop
  rts

scroll_4bpp_tile_left:
  lda #0 ;initalise a and y
  ldy #0
  @loop:
    pha ;push to stack so a and y can be used for the line scroll loop
    phy
    jsr scroll_4bpp_pixel_line_left
    pla
    clc
    adc #8
    add_a_to_16_value pixel_line_addr ;macro adds a to a 16 value
                                      ;in this case the pixel line address (we want to jump 8 bytes each loop)
    ply ;pull this loops values back to do checks
    iny
    cpy #16 ; finish after 16 rows.
    bne @loop
  rts
