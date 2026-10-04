KEY_RIGHT equ 0x13
KEY_LEFT equ 0x11
KEY_UP equ 0x12
ray_start:
  ldi a, 16
  st a, walls
  dec a
ray_loop:
  st a, i
  ldi b, 4
  st b, bank
  ldi b, rays
  add b, a
  ld b, b
  st b, f_coord
  clr c
start_bank:
  ldi d, 0x80
set_bank:
  st c, bank
  jmp d
end_ray_loop:
  ld a, i
  dec a
  jns ray_loop
ld a, walls
test a
jnz ray_start
ldi c, 6
ldi d, clear_start
jmp set_bank
wall_jmp:
  ldi c, 4
  ldi d, wall
  jmp set_bank
void1 db 0, 0, 0, 0, 0
dir db 0
f_coord db 0
f_dir db 0, 0
output_bank1 db 0
output_adress1 db 0
output_bank2 db 0
output_adress2 db 0
speed_ray_x db 0
speed_ray_y db 0
walls db 0
i db 0
in_out db 0b00010000
bank db 0
display db
0b00000000, 0b00000000,
0b00011100, 0b01110000,
0b00000010, 0b01001000,
0b00000010, 0b01001000,
0b00011100, 0b01001000,
0b00000010, 0b01001000,
0b00000010, 0b01001000,
0b00011100, 0b01110000,
0b00000000, 0b00000000,
0b00000000, 0b00000000,
0b10001000, 0b00000000,
0b11011011, 0b00110010,
0b10101001, 0b10010101,
0b10001010, 0b10100110,
0b10001001, 0b10110011,
0b00000000, 0b00000000
map db
0b00000000, 0b00100011,
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
0b00000110, 0b11101110,
0b00000010, 0b00101000,
0b00000011, 0b10101011,
0b00000010, 0b00001000


get_dir:
  mov c, a
  ldi a, dirs + 1
  ldi b, dirs
  shl c
  add a, c
  add b, c
  ld a, a
  ld b, b
  ldi c, 15
  ld d, dir
mul_loop:
  st d, j
  clr d
  add a, c
  adc b, d
  ld d, j
  dec d
  jns mul_loop
clr d
sub a, c
sbb b, d
check:
  ldi c, 359 - 256
  inc d
  sub c, a
  sbb d, b
  jnc end_get_dir
  ldi c, 360 - 256
  ldi d, 1
  sub a, c
  sbb b, d
  jmp check
end_get_dir:
  clr d
  st d, output_bank1
move_coord:
  st a, f_dir + 1
  st b, f_dir
  clr c
  st c, speed_ray_x
  st c, speed_ray_y
  ldi c, 2
  jmp start_bank
dirs db 1, 69,
1, 73,
1, 78,
1, 83,
1, 87,
1, 92,
1, 97,
1, 101,
0, 2,
0, 7,
0, 11,
0, 16,
0, 21,
0, 25,
0, 30,
0, 35
j db 0
check_player_wall:
  st a, save_coord_player
  ldi c, 7
  and c, a
  ldi b, 0b10000000
  check_player_loop:
    shr b
    dec c
    jns check_player_loop
  rcl b
  shr a
  shr a
  shr a
  ldi c, map
  add a, c
  ld c, a
  and c, b
  jnz wall_jmp
  ld a, save_coord_player
  ldi c, 4
  ldi d, end_ray_check
  jmp set_bank

save_coord_player db 0
void2 db 0, 0, 0, 0, 0, 0


check_sin:
  ldi c, 180
  clr d
  sub c, a
  sbb d, b
  jnc get_pos_sin
  ldi c, 270 - 256
  ldi d, 1
  sub c, a
  sbb d, b
  jnc sin270
sin360:
  ldi c, 360 - 256
  sub c, a
  mov a, c
  jmp get_neg_sin
sin270:
  ldi c, 180
  sub a, c
get_neg_sin:
  ldi d, neg_sin
  jmp get_sin_jmp
get_pos_sin:
  ldi d, pos_sin
get_sin_jmp:
  st d, output_adress2
  ldi c, 3
  st c, output_bank2
  ldi c, 5
  ldi d, get_sin
  jmp set_bank
check_cos:
  ld a, f_dir + 1
  ld b, f_dir
  ldi c, 90
  clr d
  sub c, a
  sbb d, b
  jnc get_pos_cos
  ldi c, 180
  clr d
  sub c, a
  sbb d, b
  jnc cos180
  ldi c, 270 - 256
  ldi d, 1
  sub c, a
  sbb d, b
  jnc cos270
cos360:
  ldi c, 360 - 256
  sub c, a
  mov a, c
get_pos_cos:
  ldi d, pos_cos
  jmp get_cos_jmp
cos180:
  ldi c, 180
  sub c, a
  mov a, c
  jmp get_neg_cos
cos270:
  ldi c, 180
  sub a, c
get_neg_cos:
  ldi d, neg_cos
get_cos_jmp:
  st d, output_adress2
  ldi c, 3
  st c, output_bank2
  ldi c, 5
  jmp start_bank

move_next:
  ldi c, map
  add a, c
  ld c, a
  and c, b
  jnz wall_jmp
  ld a, f_coord
  mov b, a
  ldi c, 0x0f
  and a, c
  not c
  and b, c
ldi c, 4
jmp start_bank
void3 db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0


neg_sin:
  ldi d, 0 - 1
  jmp check_sin_ray
pos_sin:
  ldi d, 1
check_sin_ray:
  ld b, i
  ldi c, rays_sin
  add c, b
  ld b, c
  add a, b
  jns check_cos_jmp
set_speed_x:
  st d, speed_ray_x
  shl a
  shr a
check_cos_jmp:
  st a, c
  ldi c, 2
  ldi d, check_cos
  jmp set_bank

neg_cos:
  ldi d, 1
  jmp check_cos_ray
pos_cos:
  ldi d, 0 - 1
check_cos_ray:
  ld b, i
  ldi c, rays_cos
  add c, b
  ld b, c
  add a, b
  jns move
set_speed_y:
  st d, speed_ray_y
  shl a
  shr a

move:
  st a, c
  ld a, f_coord
  ldi c, 7
  and c, a
  ldi b, 0b10000000
  loop:
    shr b
    dec c
    jns loop
  rcl b
  shr a
  shr a
  shr a
  ldi c, 2
  ldi d, move_next
  jmp set_bank


clear_sin_cos:
  clr a
  ldi c, 34
  ldi d, rays_sin
clear_sin_cos_loop:
  ldi b, 18
  xor b, c
  jz end_clear_sin_cos_loop
  test c
  jz end_clear_sin_cos_loop
  st a, d
end_clear_sin_cos_loop:
  inc d
  dec c
  jnz clear_sin_cos_loop
jmp ray_start
rays_sin db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0
rays_cos db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0

void4 db 0, 0, 0, 0, 0, 0, 0


ray_y:
  shr b
  shr b
  shr b
  shr b
  ld c, speed_ray_y
  add b, c
  test c
  jz ray_x
  js ray_up
ray_down:
  ldi c, 0x0f
  and c, b
  jz wall
  jmp ray_x
ray_up:
  jnc wall
ray_x:
  ld c, speed_ray_x
  add a, c
  test c
  jz end_ray
  js ray_left
ray_right:
  ldi c, 0x0f
  and c, a
  jz wall
  jmp end_ray
ray_left:
  jnc wall
end_ray:
  shl b
  shl b
  shl b
  shl b
  or a, b
  ld c, output_bank1
  test c
  jz end_ray_check
  clr c
  ldi d, check_player_wall
  jmp set_bank
end_ray_check:
  ld c, output_bank1
  ld d, output_adress1
  test c
  jnz set_bank
  ld b, i
  ldi c, rays
  add b, c
  st a, b
  ldi c, 6
  jmp start_bank
wall:
  ld a, f_coord
  ld c, output_bank1
  ld d, output_adress1
  test c
  jnz set_bank
  ld a, walls
  dec a
  st a, walls
  jmp end_ray_loop

clear_rays:
  ldi c, 16
  ldi d, rays
clear_rays_loop:
  st a, d
  inc d
  dec c
  jnz clear_rays_loop
ldi c, 3
ldi d, clear_sin_cos
jmp set_bank
get_ray:
  ldi c, rays
  add c, a
  ld a, c
  ldi c, 6
  ldi d, check_win
  jmp set_bank
rays db 0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4,
0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4
void5 db 0


get_cos:
  ldi b, 90
  sub b, a
  mov a, b
  jmp read_sin
get_sin:
  ldi c, 90
  sub c, a
  jnc read_sin
a180:
  ldi c, 180
  sub c, a
  mov a, c
read_sin:
  ldi b, sin
  add a, b
  ld a, a
  ld c, output_bank2
  ld d, output_adress2
  jmp set_bank
sin db 0b00000000, 0b00000010, 0b00000100, 0b00000110, 0b00001000,
0b00001011, 0b00001101, 0b00001111, 0b00010001, 0b00010100,
0b00010110, 0b00011000, 0b00011010, 0b00011100, 0b00011110,
0b00100001, 0b00100011, 0b00100101, 0b00100111, 0b00101001,
0b00101011, 0b00101101, 0b00101111, 0b00110001, 0b00110011,
0b00110101, 0b00110111, 0b00111001, 0b00111011, 0b00111101,
0b01000000, 0b01000010, 0b01000100, 0b01000101, 0b01000111,
0b01001001, 0b01001011, 0b01001101, 0b01001110, 0b01010000,
0b01010010, 0b01010100, 0b01010101, 0b01010111, 0b01011001,
0b01011010, 0b01011100, 0b01011101, 0b01011111, 0b01100001,
0b01100010, 0b01100100, 0b01100101, 0b01100110, 0b01100111,
0b01101001, 0b01101010, 0b01101011, 0b01101100, 0b01101101,
0b01101110, 0b01101111, 0b01110001, 0b01110010, 0b01110011,
0b01110100, 0b01110101, 0b01110110, 0b01110111, 0b01110111,
0b01111000, 0b01111001, 0b01111001, 0b01111010, 0b01111010,
0b01111011, 0b01111011, 0b01111100, 0b01111100, 0b01111101,
0b01111101, 0b01111110, 0b01111110, 0b01111110, 0b01111110,
0b01111111, 0b01111111, 0b01111111, 0b01111111, 0b01111111,
0b10000000

void6 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

add_step:
  ld a, i
  ldi b, steps
  add b, a
  ld a, b
  inc a
  st a, b
  jmp end_ray_loop
clear_start:
  clr a
  ldi b, 32
  ldi d, display
clear_loop:
  st a, d
  inc d
  dec b
  jnz clear_loop
step_start:
  ldi b, steps
step_loop:
  st a, k
  ldi c, 4
  ldi d, get_ray
  jmp set_bank
  check_win:
    ldi c, 0x0f
    xor a, c
    jz step_loop_end
  ld a, b
  clr c
  st c, b
  ldi c, 15
  sub c, a
  jnc set_iter
  ldi a, 15
set_iter:
  ldi c, 16
  sub c, a
  st c, save
  ldi c, 64
  add a, c
  ldi d, 1
  and d, a
  add a, d
  ld c, k
  ldi d, 7
  sub d, c
  jnc set_mask
  inc a
set_mask:
  ldi d, 7
  and d, c
  ldi c, 0b10000000
  loop2:
    shr c
    dec d
    jns loop2
  rcl c
  ld d, save
  st b, save
  draw_loop:
    ld b, a
    or b, c
    st b, a
    inc a
    inc a
    dec d
    jnz draw_loop
  ld b, save
step_loop_end:
  inc b
  ld a, k
  inc a
  ldi c, 16
  xor c, a
  jnz step_loop
ldi c, 7
ldi d, key_read
jmp set_bank
steps db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0
save db 0
stop db 0
k db 0
void7 db 0, 0, 0, 0, 0
key_read:
  ld a, in_out
  ldi b, KEY_UP
  xor b, a
  jz move_player
  ldi b, KEY_RIGHT
  xor b, a
  jz turn_right
  ldi b, KEY_LEFT
  xor b, a
  jnz key_read
turn_left:
  ld a, dir
  dec a
  jns save_dir
  ldi a, 23
  jmp save_dir
turn_right:
  ld a, dir
  inc a
  ldi b, 24
  xor b, a
  jnz save_dir
  clr a
save_dir:
  st a, dir
  ld a, coord_player
  ldi c, 4
  ldi d, clear_rays
  jmp set_bank
move_player:
  ld a, coord_player
  st a, f_coord
  clr a
  clr b
  ldi c, 15
  ld d, dir
mul_dir_loop:
  st d, l
  clr d
  add a, c
  adc b, d
  ld d, l
  dec d
  jns mul_dir_loop
clr d
sub a, c
sbb b, d
ldi c, 16
st c, i
ldi c, 7
st c, output_bank1
ldi d, save_coord
st d, output_adress1
clr c
ldi d, move_coord
jmp set_bank
save_coord:
  st a, coord_player
  ldi c, 4
  ldi d, clear_rays
  ldi b, 0xc4
  xor b, a
  jnz set_bank
inc b
st b, in_out
ldi c, win_text
ldi d, 0x3c
win_loop:
  ld a, c
  st a, d
  inc c
  jnz win_loop
hlt
l db 0
coord_player db 0xe4
void8 db 0, 0, 0, 0, 0
win_text db "  You win!\n\n"