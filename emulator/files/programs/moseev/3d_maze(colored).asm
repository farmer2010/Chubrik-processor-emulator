start_coord equ 0xe3
start:
ldi c, 4
ldi d, start_rays
set_bank:
  st c, bank
  jmp d
to_move:
  st a, cos
  ldi c, 2
  st c, bank
  jmp move
ray_wall:
  ld a, walls
  dec a
  st a, walls
  ldi c, 4
  st c, bank
  jmp check_end_ray
to_end_ray:
  ldi c, 4
  st c, bank
  jmp end_ray
read_color_step:
  st d, bank
  ld b, b
  ld c, c
  inc d
  st d, bank
  jmp next_draw
void db 0
player_coord db start_coord
dir db 0
speed db 0
speed_x db 0
speed_y db 0
sin db 0
cos db 0
save1 db 0
save2 db 0
walls db 0
i db 0
f_output_adress_wall db 0
f_bank_output_load db 0
f_adress_output db 0
f_adress_load_sin db 0
f_adress_load_cos db 0
f_coord db 0
f_dir db 0
terminal db 0, 0
in_out db 0b00110001
bank db 0
display_r db
0b00000000, 0b00100010,
0b00000000, 0b00101010,
0b00111010, 0b00101010,
0b00101010, 0b00101010,
0b00101111, 0b11101010,
0b00100000, 0b00101000,
0b00001110, 0b00101011,
0b00001010, 0b00101000,
0b00101010, 0b00101110,
0b00101010, 0b00101000,
0b00100010, 0b00101011,
0b00111110, 0b00101000,
0b00000010, 0b11101110,
0b00000010, 0b00101000,
0b00000011, 0b10101011,
0b00000010, 0b00001000
display_b db
0b00000000, 0b00000001,
0b00000000, 0b00000000,
0b00011000, 0b00000000,
0b00000000, 0b00000000,
0b00001111, 0b11000000,
0b00000000, 0b00000000,
0b00001110, 0b00000011,
0b00000000, 0b00000000,
0b00000000, 0b00000110,
0b00000000, 0b00000000,
0b00000000, 0b00000011,
0b00111100, 0b00000000,
0b00000000, 0b11000110,
0b00000000, 0b00000000,
0b00000001, 0b10000011,
0b00000000, 0b00000000
raycast:
start_sin:
  ld a, f_dir
  clr c
  st c, speed_x
  st c, speed_y
  ld d, f_adress_load_sin
  ldi b, 1
  jmp get_sin

add_cos:
  add a, b
  jns to_move
  ld c, speed
  st c, speed_y
  shl a
  shr a
  jmp to_move

add_sin:
  add a, b
  jns start_cos
  ld c, speed
  st c, speed_x
  shl a
  shr a

start_cos:
  st a, sin
  ld a, f_dir
  ld d, f_adress_load_cos
  ldi b, 0 - 1

get_cos:
  ldi c, 45
  sub c, a
  mov a, c
  jnc get_sin
  ldi c, 180
  add a, c

get_sin:
  ldi c, 90
  sub c, a
  jc neg_sin
pos_sin:
  st b, speed
  jmp read_sin
neg_sin:
  neg b
  st b, speed
  ldi c, 90
  sub a, c
read_sin:
  ldi c, 45
  sub c, a
  jnc read
  ldi c, 90
  sub c, a
  mov a, c
read:
  ldi c, table_sin
  add a, c
  ld a, a
  ld c, f_bank_output_load
  jmp set_bank

table_sin db 0b00000000, 0b00000100, 0b00001000, 0b00001101, 0b00010001,
0b00010110, 0b00011010, 0b00011110, 0b00100011, 0b00100111,
0b00101011, 0b00101111, 0b00110011, 0b00110111, 0b00111011,
0b01000000, 0b01000100, 0b01000111, 0b01001011, 0b01001110,
0b01010010, 0b01010101, 0b01011001, 0b01011100, 0b01011111,
0b01100010, 0b01100101, 0b01100111, 0b01101010, 0b01101100,
0b01101110, 0b01110001, 0b01110011, 0b01110101, 0b01110111,
0b01111000, 0b01111001, 0b01111010, 0b01111011, 0b01111100,
0b01111101, 0b01111110, 0b01111110, 0b01111111, 0b01111111,
0b10000000

move:
  ld a, f_coord
  mov b, a
  ldi d, 0x0f
  and a, d
  shr b
  shr b
  shr b
  shr b
move_x:
  ld c, speed_x
  add a, c
  test c
  jz move_y
  js move_left
move_right:
  and a, d
  jz wall_edge
  jmp move_y
move_left:
  test a
  js wall_edge
move_y:
  ld c, speed_y
  add b, c
  test c
  jz move_end
  js move_up
move_down:
  and b, d
  jnz move_end
wall_edge:
  ldi a, 3
  ld c, f_bank_output_load
  ld d, f_output_adress_wall
  jmp set_bank
move_up:
  test b
  js wall_edge
move_end:
  st a, save1
  st b, save2
  ldi c, 7
  and c, a
  shr a
  shr a
  shr a
  shl b
  add b, a
  ldi a, 0b10000000
  shr_loop:
    shr a
    dec c
    jns shr_loop
  rcl a
  ldi c, 3
  ldi d, check_wall
  jmp set_bank

set_settings_player:
  ldi a, 7
  st a, f_bank_output_load
  ldi a, check_game_over
  st a, f_output_adress_wall
  ldi a, save_coord_player
  st a, f_adress_output
  ldi a, player_load_sin
  st a, f_adress_load_sin
  ldi a, player_load_cos
  st a, f_adress_load_cos
  ld a, player_coord
  st a, f_coord
  ld a, dir
  st a, f_dir
  clr c
  ldi d, raycast
  jmp set_bank

void3 db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0

check_wall:
  ldi d, ver
  add d, b
  ld c, d
  and c, a
  jz check_hor
  ldi a, 1
  jmp wall_jmp
check_hor:
  ldi d, hor
  add d, b
  ld c, d
  and c, a
  jz check_win
  ldi a, 3
  jmp wall_jmp
check_win:
  shr a
  jnc save_jmp
check_win_adress:
  dec b
  jnz save_jmp
  ldi a, 2
wall_jmp:
  ld c, f_bank_output_load
  ld d, f_output_adress_wall
  jmp set_bank
save_jmp:
  ld a, save1
  ld b, save2
  shl b
  shl b
  shl b
  shl b
  or a, b
  ld c, f_bank_output_load
  ld d, f_adress_output
  jmp set_bank

void4 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

hor db
0b00000000, 0b00000000,
0b00000000, 0b00000000,
0b00011000, 0b00000000,
0b00000000, 0b00000000,
0b00001111, 0b11000000,
0b00000000, 0b00000000,
0b00001110, 0b00000011,
0b00000000, 0b00000000,
0b00000000, 0b00000110,
0b00000000, 0b00000000,
0b00000000, 0b00000011,
0b00111100, 0b00000000,
0b00000000, 0b11000110,
0b00000000, 0b00000000,
0b00000001, 0b10000011,
0b00000000, 0b00000000
ver db
0b00000000, 0b00100010,
0b00000000, 0b00101010,
0b00100010, 0b00101010,
0b00101010, 0b00101010,
0b00100000, 0b00101010,
0b00100000, 0b00101000,
0b00000000, 0b00101000,
0b00001010, 0b00101000,
0b00101010, 0b00101000,
0b00101010, 0b00101000,
0b00100010, 0b00101000,
0b00000010, 0b00101000,
0b00001110, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00001000

start_rays:
  ldi b, 16
  st b, walls
  dec b
start_ray:
  st b, i
set_settings:
  ldi a, 5
  st a, f_bank_output_load
  ldi a, save_color
  st a, f_output_adress_wall
  ldi a, next_step
  st a, f_adress_output
  ldi a, ray_load_sin
  st a, f_adress_load_sin
  ldi a, ray_load_cos
  st a, f_adress_load_cos
  ldi c, coord_rays
  add c, b
  ld a, c
  st a, f_coord
  shl b
  ldi a, 165
  add a, b
  clr b
  ld c, dir
  add a, c
  jnc dir_mod
  inc b
dir_mod:
  ldi c, 179
  clr d
  sub c, a
  sbb d, b
  jnc set_dir
  ldi c, 180
  clr d
  sub a, c
  sbb b, d
  jmp dir_mod
set_dir:
  st a, f_dir
  clr c
  ldi d, raycast
  jmp set_bank

end_ray:
  ldi c, coord_rays
  add c, b
  st a, c
check_end_ray:
  dec b
  jns start_ray
  ld a, walls
  test a
  jnz start_rays
  ldi c, 6
  ldi d, clear_display
  jmp set_bank

clear_coord_rays:
  ldi b, clear_coord_rays_loop
  ldi d, coord_rays
clear_coord_rays_loop:
  st a, d
  inc d
  jnz b
clr a
ldi c, 5
ldi d, clear
jmp set_bank

void5 db 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0

coord_rays db start_coord, start_coord, start_coord, start_coord,
start_coord, start_coord, start_coord, start_coord,
start_coord, start_coord, start_coord, start_coord,
start_coord, start_coord, start_coord, start_coord
ray_load_sin:
  ld b, i
  ldi c, sin_rays
  add c, b
  ld b, c
  clr c
  ldi d, add_sin
  jmp set_bank
ray_load_cos:
  ld b, i
  ldi c, cos_rays
  add c, b
  ld b, c
  clr c
  ldi d, add_cos
  jmp set_bank

save_color:
  ld b, i
  ldi d, rays_color
  add d, b
  st a, d
  jmp ray_wall

next_step:
  ld b, i
  ldi d, sin_rays
  add d, b
  ld c, sin
  st c, d
  ldi d, cos_rays
  add d, b
  ld c, cos
  st c, d
  ldi d, rays_steps
  add d, b
  ld c, d
  inc c
  st c, d
  jmp to_end_ray

clear:
  ldi b, clear_loop
  ldi d, rays_steps
clear_loop:
  st a, d
  inc d
  jnz b
jmp start

void6 db 0, 0, 0

rays_color db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0
rays_steps db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0

sin_rays db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0
cos_rays db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0

clear_display:
  clr a
  ldi b, clear_display_loop
  ldi d, display_r
clear_display_loop:
  st a, d
  inc d
  jns b
;b - позиция
;c - кол-во повторений
;d - адрес
draw:
  st a, i
  ldi b, rays_color
  add b, a
  ldi c, rays_steps
  add c, a
  ldi d, 5
  jmp read_color_step
  next_draw:
    st b, color
    ldi d, 15
    sub d, c
    jnc i_to_pos
    ldi c, 15
  i_to_pos:
    ldi d, 7
    and d, a
    ldi b, 0b10000000
    draw_shr_loop:
      shr b
      dec d
      jns draw_shr_loop
    rcl b
  ldi d, 16
  sub d, c
  mov c, d
  st c, iter
check_red:
  ld d, color
  shr d
  jnc check_blue
  ldi d, check_blue
  st d, next
  ldi d, display_r + 16
  jmp draw_wall
check_blue:
  ld d, color
  shr d
  shr d
  jnc draw_end
  ldi d, draw_end
  st d, next
  ldi d, display_b + 16
  jmp draw_wall
draw_end:
  inc a
  ldi b, 16
  xor b, a
  jnz draw
ldi c, 7
ldi d, key_read
jmp set_bank
draw_wall:
  shr c
  shl c
  sub d, c
  shr a
  shr a
  shr a
  add d, a
  ld c, iter
draw_wall_loop:
  ld a, d
  or a, b
  st a, d
  inc d
  inc d
  dec c
  jnz draw_wall_loop
ld a, i
ld c, iter
ld d, next
jmp d
next db 0
iter db 0
color db 0
void7 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0
key_read:
  ld a, in_out
  ldi b, 0x11
  sub a, b
  jz left
  dec a
  jz move_player
  dec a
  jnz key_read
right:
  ld a, player_dir + 1
  ld b, player_dir
  ldi c, 15
  clr d
  add a, c
  adc b, d
  ldi c, 359 - 256
  inc d
  sub c, a
  sbb d, b
  jnc save_dir
  clr a
  clr b
  jmp save_dir
left:
  ld a, player_dir + 1
  ld b, player_dir
  ldi c, 15
  clr d
  sub a, c
  sbb b, d
  jnc save_dir
  ldi a, 89
  ldi b, 1
save_dir:
  st a, player_dir + 1
  st b, player_dir
  shr b
  rcr a
  st a, dir
jmp_clear:
  ld a, player_coord
  ldi c, 4
  ldi d, clear_coord_rays
  jmp set_bank
move_player:
  ldi c, 2
  ldi d, set_settings_player
  jmp set_bank
player_load_sin:
  ld b, sin_player
  clr c
  ldi d, add_sin
  jmp set_bank
player_load_cos:
  ld b, cos_player
  clr c
  ldi d, add_cos
  jmp set_bank
check_game_over:
  dec a
  dec a
  jz game_over
  jmp jmp_clear
save_coord_player:
  st a, player_coord
  ld a, sin
  st a, sin_player
  ld a, cos
  st a, cos_player
  jmp jmp_clear
game_over:
  ldi b, game_over_loop
  ldi c, text_game_over
  ldi d, terminal
game_over_loop:
  ld a, c
  st a, d
  inc c
  jnz b
hlt
void8 db 0
player_dir db 0, 0
sin_player db 0
cos_player db 0
text_game_over db "  You win!"