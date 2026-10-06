ldi a, 100
st a, balance
jmp ask
set_bank:
  st c, bank
  jmp d
text_ask_loop:
  ld a, c
  st a, d
  inc c
  dec b
  jnz text_ask_loop
num1:
  ld a, in_out
  mov c, a
  ldi b, "1"
  sub a, b
  jc num1
  inc a
  ldi b, 9
  sub b, a
  jc num1
  st c, d
  mov c, a
  clr d
num2:
  ld a, in_out
  st a, symbol
  ldi b, "\n"
  xor b, a
  jz end_ask
  ldi b, "0"
  sub a, b
  jc num2
  ldi b, 9
  sub b, a
  jc num2
  jmp mul
current_symbol db s1
bid db 0
bid256 db 0
save db 0
symbol db 0
balance db 0
balance256 db 0
terminal db 0
terminal_art db 0
in_out db 0b00111101
bank db 0
display_r db
0b00000000, 0b00000000,
0b00000000, 0b00000111,
0b00000000, 0b00000110,
0b11011011, 0b01101100,
0b11011011, 0b01101000,
0b00000000, 0b00000000,
0b11110011, 0b11001111,
0b00010000, 0b01000001,
0b00100000, 0b10000010,
0b01000001, 0b00000100,
0b01000001, 0b00000100,
0b00000000, 0b00000000,
0b01000000, 0b10000011,
0b00010100, 0b00010111,
0b01000001, 0b01000010,
0b00001000, 0b00001010
display_b db
0b11000011, 0b00000010,
0b10100010, 0b10000000,
0b10010010, 0b01000000,
0b00000000, 0b00000000,
0b00000000, 0b00000000,
0b00000000, 0b00000000,
0b11110011, 0b11001111,
0b00010000, 0b01000001,
0b00100000, 0b10000010,
0b01000001, 0b00000100,
0b01000001, 0b00000100,
0b00000000, 0b00000000,
0b00001000, 0b00001011,
0b11000001, 0b01000011,
0b00010100, 0b00010110,
0b01000000, 0b10000010
ask_enter:
  ldi a, "\n"
  st a, terminal
ask:
  ldi a, 9
  st a, num2 + 15
  ldi b, text_ask_size
  ldi c, text_ask
  ldi d, terminal
  jmp text_ask_loop
mul:
  st a, save
  ld a, symbol
  st a, terminal
  mov a, c
  mov b, d
  shl c
  rcl d
  shl c
  rcl d
  add c, a
  adc d, b
  shl c
  rcl d
  ld a, save
  add c, a
  clr a
  adc d, a
  ldi a, 204
  ldi b, 12
  sub a, c
  sbb b, d
  jz new_settings
  jnc num2
end_ask:
  ldi a, "Р"
  st a, terminal
  ld a, balance
  ld b, balance256
  sub a, c
  sbb b, d
  jo ask_enter
  st a, balance
  st b, balance256
  st c, bid
  st d, bid256
spin:
  ld a, 0x3e
  st a, save
  ldi a, "\n"
  st a, terminal
choose_symbol:
  rnd a
  clr b
  ldi c, 27
  sub a, c
  jc draw_symbol_jmp
  inc b
  ldi c, 52
  sub a, c
  jc draw_symbol_jmp
  inc b
  ldi c, 77
  sub a, c
  jc draw_symbol_jmp
  inc b
draw_symbol_jmp:
  ldi c, 2
  ldi d, draw_symbol
  jmp set_bank
new_settings:
  ldi a, 7
  st a, num2 + 15
  jmp num2
text_ask db "Ставка:\n"
text_ask_size equ $ - text_ask
void1 db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0
draw_symbol:
  ld a, current_symbol
  st b, a
  inc a
  st a, current_symbol
  mov a, b
  shl b
  shl b
  add b, a
  ldi a, symbols
  add b, a
symbols_start:
  ldi d, terminal_art
  ldi c, 5
  symbols_loop:
    ld a, b
    st a, d
    inc b
    dec c
    jnz symbols_loop
  st c, d
  ld a, current_symbol
  ldi b, s3 + 1
  xor a, b
  jnz next_symbol
  ld b, save
  test b
  jz spin_jmp
xor_symbols_jmp:
  ld a, s1
  ld b, s2
  xor a, b
  jnz lose_jmp
  ld a, s3
  xor b, a
  jnz lose_jmp
  ld b, s1
  xor a, b
  jnz lose_jmp
  ldi a, 10
  dec b
  js mul_bid
  ldi a, 7
  dec b
  js mul_bid
  ldi a, 4
  dec b
  js mul_bid
  ldi a, 2
mul_bid:
  ldi c, 4
  ldi d, mul_bid_start
  jmp set_bank
next_symbol:
  ldi d, choose_symbol
  jmp set_bank
spin_jmp:
  ldi d, s1
  st d, current_symbol
  ldi d, spin
  jmp set_bank
lose_jmp:
  ldi c, 4
  ldi d, check_lose
  jmp set_bank
symbols:
  seven db
  0b00000011,
  0b11110011,
  0b11111011,
  0b00011111,
  0b00001111
  pepper db
  0b11000000,
  0b01110000,
  0b01111100,
  0b00111111,
  0b00011101
  cherry db
  0b11111111,
  0b11000001,
  0b00000010,
  0b01111100,
  0b01100000
  strawberry db
  0b00011101,
  0b01110110,
  0b11101111,
  0b01110110,
  0b00011101
s1 db 0
s2 db 0
s3 db 0
void2 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
text_start:
  ldi d, terminal
  ldi c, "\n"
  st c, d
text_loop:
  ld c, a
  test c
  jz b
  st c, d
  inc a
  jmp text_loop
ask_jmp:
  ldi c, s1
  st c, current_symbol
  clr c
  ldi d, ask
  jmp set_bank
end:
  hlt
text_Lose db "Коллектор:\n", '"ОТКРЫВАЙ"\n', "*звуки боли*", 0
text_lose db "Промах!\n", 0
text_win db "Попадание!\n", 0
text_Win db "Поздравляю! ", "Ты заработал", "на казике!!!", 0
void3 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
mul_bid_start:
  clr b
  clr c
  clr d
mul_bid_loop:
  st a, i
  ld a, bid
  add b, a
  ld a, bid256
  adc c, a
  clr a
  adc d, a
  ld a, i
  dec a
  jnz mul_bid_loop
add_balance:
  ld a, balance
  add b, a
  ld a, balance256
  adc c, a
  test a
  clr a
  jns add_balance65536
  dec a
add_balance65536:
  adc d, a
  js win
  jnz Win
  test c
  js Win
win:
  st b, balance
  st c, balance256
  ldi a, text_win
  ldi b, ask_jmp
  jmp text_start_jmp
Win:
  ldi a, 255
  st a, balance
  shr a
  st a, balance256
  ldi a, text_Win
  ldi b, end
  jmp text_start_jmp
check_lose:
  ld a, balance
  ld b, balance256
  test a
  jnz lose
  neg b
  jno lose
Lose:
  ldi a, text_Lose
  ldi b, end
  jmp text_start_jmp
lose:
  ldi a, text_lose
  ldi b, ask_jmp
text_start_jmp:
  ldi c, 3
  ldi d, text_start
  jmp set_bank
i db 0
