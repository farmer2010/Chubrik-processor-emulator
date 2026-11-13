COLORED equ 0b00110100
NO_DISPLAY equ 0b00000100

KEY_UP equ 0x12
KEY_RIGHT equ 0x13
KEY_DOWN equ 0x14
KEY_LEFT equ 0x11

BANK_MAIN equ 1
BANK_RAY equ 2
BANK_DRAW equ 3
BANK_MATH equ 4
BANK_MAP equ 4
BANK_SIN equ 5
BANK_MOVE equ 6
BANK_COLLIDE equ 7

VIEW_DIST equ 14
v2 equ VIEW_DIST + VIEW_DIST
VIEW_DIST4 equ v2 + v2;view dist * 4

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                       ОБЩАЯ ОБЛАСТЬ                         W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 0

jmp start

void db 0

draw_point:;a - display addr, c - out
st c, fn_out_index

ld b, buffer + 5
shl b
add b, a
ldi a, buffer + 2

ld c, a
ld d, b
or c, d
st c, b

inc a
inc b

ld c, a
ld d, b
or c, d
st c, b

ld c, fn_out_index
jmp c


;###############################################################
change_bank:;переход между банками. c - индекс банка, d - индекс перехода
st c, bank
jmp d
;###############################################################

buffer db 0,0,0,0,0,0,0

fn_out_index db 0
fn_out_bank db 0

collide_out_index equ distances + 10

color db 0;10 - red, 01 - blue

distances db 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0

rotate db 0
player_x db 16,0
player_y db 16,0

indicator1 db 0;0x3A
indicator2 db 0;0x3B
map_out_bank db 0;0x3C
terminal_graphics db 0;0x3D
connect db COLORED;0x3E
bank db 1;0x3F

display db      0b11000100, 0b10100000,
                0b10101010, 0b10100000,
                0b11001110, 0b01100000,
                0b10101010, 0b00100000,
                0b10101010, 0b11000000,
                0b00001100, 0b10001100,
                0b00010001, 0b01010000,
                0b00010001, 0b11001000,
                0b00010001, 0b01000100,
                0b00001101, 0b01011000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000

display_blue db 0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00001100, 0b10001100,
                0b00010001, 0b01010000,
                0b00010001, 0b11001000,
                0b00010001, 0b01000100,
                0b00001101, 0b01011000,
                0b00000111, 0b00110110,
                0b00000010, 0b01000101,
                0b00000010, 0b01110110,
                0b00000010, 0b01000101,
                0b00000010, 0b01110101,
                0b00000000, 0b00000000


;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 1                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 1

cycle:
ld a, connect
ldi b, KEY_UP
sub b, a
ldi b, 1
st b, move_up_or_down
ldi c, BANK_MOVE
ldi d, move
jz change_bank

ldi b, KEY_DOWN
sub b, a
clr b
st b, move_up_or_down
ldi c, BANK_MOVE
ldi d, move
jz change_bank

ldi b, KEY_LEFT
sub b, a
jnz not_rot_left
	ld a, rotate
	dec a
	st a, rotate
	jmp start
not_rot_left:

ldi b, KEY_RIGHT
sub b, a
jnz cycle
	ld a, rotate
	inc a
	st a, rotate
	jmp start

start:

ldi a, NO_DISPLAY
st a, connect
ldi c, BANK_SIN
ldi d, raycast
jmp change_bank

draw_return:
ldi a, COLORED
st a, connect

ldi a, display
ldi b, 64
redraw_cycle:
	ld c, a
	st c, a
inc a
dec b
jnz redraw_cycle

jmp cycle

void1 db 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 
		 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 2                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW

ray_x db 0,0
ray_y db 0,0
sin_val db 0,0
cos_val db 0,0

ray:

ldi a, ray_x
ldi b, player_x
ldi c, 4
load_pl_coord:
	ld d, b
	st d, a
	inc a
	inc b
dec c
jnz load_pl_coord

ldi a, BANK_RAY
st a, fn_out_bank
st a, map_out_bank

ld a, buffer + 2
ldi b, $ + 8
ldi c, BANK_SIN
ldi d, sin
jmp change_bank
st a, sin_val
st b, sin_val + 1

ld a, buffer + 2
ldi b, $ + 8
ldi c, BANK_SIN
ldi d, cos
jmp change_bank
st a, cos_val
st b, cos_val + 1


clr a;distance
st a, buffer + 1
ray_cycle:
	ld a, ray_x;move x
	ld b, ray_x + 1
	ld c, cos_val
	ld d, cos_val + 1
	add b, d
	adc a, c
	st a, ray_x
	st b, ray_x + 1
	
	ld a, ray_y;move y
	ld b, ray_y + 1
	ld c, sin_val
	ld d, sin_val + 1
	add b, d
	adc a, c
	st a, ray_y
	st b, ray_y + 1
	
	ld a, ray_x;position on map
	ld b, ray_y
	shr a
	shr b
	
	ldi d, $ + 10;get map pixel
	st d, fn_out_index
	ldi c, BANK_MAP
	ldi d, get_point
	jmp change_bank
	test a
	jz not_collide
		ld a, buffer + 1
		inc a
		jmp ray_cycle_end
	not_collide:
ld a, buffer + 1
inc a
st a, buffer + 1
ldi b, VIEW_DIST4
sub b, a
jnz ray_cycle
ray_cycle_end:

ldi c, BANK_SIN
ldi d, ray_return
jmp change_bank

void2 db 0,0

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 3                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW

draw:

ldi a, display
ldi b, 64
clr d

clear_cycle:
st d, a

inc a
dec b
jnz clear_cycle

ldi a, distances
ldi b, 0b10000000
clr c
ldi d, 16
st a, buffer + 1;distances addr
st b, buffer + 2;mask
st c, buffer + 3
st d, buffer + 4;iterator

draw_cycle:
	ldi c, BANK_MATH
	ldi d, division
	jmp change_bank
	division_end:

	ldi b, 9
	sub b, a
	jnc less_9
	ldi a, 9
	less_9:
	st a, buffer;v
	
	ldi c, BANK_MATH
	ldi d, set_color
	jmp change_bank
	set_color_return:

	ldi b, 15;j
	st b, buffer + 5
	line_cycle:
		ld a, buffer
		ldi c, 9
		sub c, a
		sub b, c
		jc skip_draw
		test1_confirmed:
		
		add b, c
		ldi c, 7
		add c, a
		sub c, b
		jc skip_draw
		jz skip_draw
		test2_confirmed:
			ld c, color
			ldi d, 0b00000010
			and c, d
			jz not_draw_red
			
			ldi a, display
			ldi c, $ + 4
			jmp draw_point
			
			not_draw_red:
			
			ld c, color
			ldi d, 0b00000001
			and c, d
			jz not_draw_blue
			
			ldi a, display_blue
			ldi c, $ + 4
			jmp draw_point
			
			not_draw_blue:
		skip_draw:
	ld b, buffer + 5
	dec b
	st b, buffer + 5
	jns line_cycle
ld a, buffer + 1;distances addr
ld b, buffer + 2;mask
ld c, buffer + 3
ld d, buffer + 4;iterator

inc a
shr b
rcr c
dec d

st a, buffer + 1;distances addr
st b, buffer + 2;mask
st c, buffer + 3
st d, buffer + 4;iterator

jnz draw_cycle

ldi c, BANK_MAIN
ldi d, draw_return
jmp change_bank


;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 4                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW

division:;a - делимое(частное), b - делитель
;c - остаток

ld b, a
ldi a, 128

clr c

ldi d, 8
div_cycle:

shl a
rcl c

sub c, b
jc remainder_not_fit

inc a
jmp div_end
remainder_not_fit:

add c, b

div_end:

dec d
jnz div_cycle

ldi c, BANK_DRAW
ldi d, division_end
jmp change_bank


;###############################################################
;функция получения байта дисплея, его координаты и координаты бита. a - x, b - y

;сама функция
get_point:

ldi c, 0b00000111;индекс бита(0 - старший)
and c, a
st c, buffer;временно сохраняем в память

shl b;умножаем ypos на 2

ldi c, 0b00001000;если xpos > 7, прибавляем 1
and c, a
test c
jz plus_1_end

inc b
plus_1_end:
ld a, buffer;a - индекс бита(0 - старший), b - индекс байта

ldi c, 7;вычитаем a из 7, чтобы 0 стал младшим битом
sub c, a
mov a, c

ldi c, 1
pow:;получаем в c число с активным битом номер a
test a
jz pow_end
shl c
dec a
jmp pow
pow_end:

ldi a, map;прибавляем к b адрес дисплея
add b, a
ld a, b;считываем нужный байт из дисплея

;возвращает: a - байт дисплея, b - адрес на дисплее, c - маска для получения нужного бита
and a, c
;в а значение нужной клетки

ld c, map_out_bank
ld d, fn_out_index
jmp change_bank

map db 0b11111111, 0b11111111,
	   0b10010000, 0b00000001,
	   0b10010000, 0b00000001,
	   0b10011110, 0b01111111,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10011111, 0b11111001,
	   0b10000000, 0b00001001,
	   0b10000000, 0b00000001,
	   0b10010010, 0b01001111,
	   0b10010010, 0b00000001,
	   0b10010010, 0b00000001,
	   0b11110010, 0b01111001,
	   0b10000010, 0b00001001,
	   0b10000010, 0b00001001,
	   0b11111111, 0b11111111


set_color:

ldi b, 7
sub b, a
jnc not_red

ldi c, 0b00000010
jmp set_color_end
not_red:

ldi b, 3
sub b, a
jnc not_blue

ldi c, 0b00000001
jmp set_color_end
not_blue:

ldi c, 0b00000011

set_color_end:
st c, color

ldi c, BANK_DRAW
ldi d, set_color_return
jmp change_bank

void4 db 0,0,0,0,0

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 5                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW

;косинус есть синус, сдвинутый на четверть оборота по x
cos:;a - angle
ldi c, 16
add a, c
sin:;a - angle, b - output index
st b, fn_out_index
mov c, a

ldi d, 0b00011111
and d, c

ldi a, sin_table
add d, a

clr a
ld b, d

ldi d, 0b00100000
and c, d
jz sin_positive

clr c
clr d

sub d, b
sbb c, a

mov a, c
mov b, d

sin_positive:

ld c, fn_out_bank
ld d, fn_out_index
jmp change_bank

sin_table db 0x00,0x06,0x0c,0x12,;СИ
             0x18,0x1e,0x23,0x28,;НУ
             0x2d,0x31,0x35,0x38,;СЫ
             0x3b,0x3d,0x3e,0x3f,
             0x40,0x3f,0x3e,0x3d,
             0x3b,0x38,0x35,0x31,
             0x2d,0x28,0x23,0x1e,
             0x18,0x12,0x0c,0x06

raycast:

ld a, rotate
ldi b, 0b00111111
and a, b
st a, indicator1

ldi b, 8
sub a, b

st a, buffer + 2
ldi a, 16
st a, buffer + 3
ldi a, distances
st a, buffer + 4

raycast_cycle:
ldi c, BANK_RAY
ldi d, ray
jmp change_bank
ray_return:
ld b, buffer + 4
st a, b

ld a, buffer + 2
inc a
st a, buffer + 2

ld a, buffer + 4
inc a
st a, buffer + 4

ld a, buffer + 3
dec a
st a, buffer + 3
jnz raycast_cycle

ldi c, BANK_DRAW
ldi d, draw
jmp change_bank

void5 db 0,0,0,0,0,0,0,0,0,0, 0,0,0

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 6                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW

move_up_or_down equ distances + 9

move:

ldi a, BANK_MOVE
st a, fn_out_bank

ldi b, $ + 10
ld a, rotate
ldi c, BANK_SIN
ldi d, cos
jmp change_bank

ld c, player_x

ld d, move_up_or_down
test d
jz move_x_down
ld d, player_x + 1
add d, b
adc c, a
jmp move_x_end
move_x_down:
ld d, player_x + 1
sub d, b
sbb c, a
move_x_end:

st c, collide_xpos
st d, collide_xpos + 1

ldi c, $ + 10
st c, collide_out_index
ldi c, BANK_COLLIDE
ldi d, collide_xpos_change
jmp change_bank
jnz collided_x

st a, player_x
st b, player_x + 1

collided_x:


ldi b, $ + 10
ld a, rotate
ldi c, BANK_SIN
ldi d, sin
jmp change_bank

ld c, player_y

ld d, move_up_or_down
test d
jz move_y_down
ld d, player_y + 1
add d, b
adc c, a
jmp move_y_end
move_y_down:
ld d, player_y + 1
sub d, b
sbb c, a
move_y_end:

st c, collide_ypos
st d, collide_ypos + 1

ldi c, $ + 10
st c, collide_out_index
ldi c, BANK_COLLIDE
ldi d, collide_ypos_change
jmp change_bank
jnz collided_y

st a, player_y
st b, player_y + 1

collided_y:

ldi c, BANK_MAIN
ldi d, start
jmp change_bank

void6 db 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 7                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW

collide_xpos equ buffer + 1
collide_ypos equ buffer + 3
collide_iterator equ buffer + 5
collide_movelist_addr equ buffer + 6

collide_mapx equ distances;distances используются только для отрисовки, поэтому их можно использовать в качестве буфера
collide_pos_addr equ distances + 1

collide_xpos_change:

ldi a, collide_xpos
st a, collide_pos_addr

ld a, player_y
ld b, player_y + 1
st a, collide_ypos
st b, collide_ypos + 1
jmp collide

collide_ypos_change:

ldi a, collide_ypos
st a, collide_pos_addr

ld a, player_x
ld b, player_x + 1
st a, collide_xpos
st b, collide_xpos + 1

collide:

ldi a, 4
st a, collide_iterator
ldi a, movelist
st a, collide_movelist_addr

ldi a, BANK_COLLIDE
st a, map_out_bank
ldi a, collide_read_map_return
st a, fn_out_index

collide_cycle:
	ld a, collide_movelist_addr
	ld c, a
	inc a
	ld d, a
	inc a
	st a, collide_movelist_addr
	
	ld a, collide_xpos
	ld b, collide_xpos + 1
	
	add b, d
	adc a, c
	shr a
	st a, collide_mapx
	
	
	ld a, collide_movelist_addr
	ld c, a
	inc a
	ld d, a
	inc a
	st a, collide_movelist_addr
	
	ld b, collide_ypos
	ld a, collide_ypos + 1
	
	add a, d
	adc b, c
	shr b
	
	ld a, collide_mapx
	
	ldi c, BANK_MAP
	ldi d, get_point
	jmp change_bank
	collide_read_map_return:
	mov d, a
	test a
	jnz succesful_collide
ld a, collide_iterator
dec a
st a, collide_iterator
jnz collide_cycle
clr d

succesful_collide:

ld c, collide_pos_addr
ld a, c
inc c
ld b, c

test d

ldi c, BANK_MOVE
ld d, collide_out_index
jmp change_bank

movelist db 255,128,   255,128,;left-up
			0,  128,   255,128,;right-up
			0,  128,   0,  128,;right-down
			255,128,   0,  128;left-down


void7 db 0,0,0,0,0,0
