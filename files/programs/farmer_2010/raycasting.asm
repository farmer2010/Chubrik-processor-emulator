COLORED equ 0b00110101

BANK_MAIN equ 1
BANK_RAY equ 2
BANK_DRAW equ 3
BANK_MATH equ 4
BANK_MAP equ 4
BANK_SIN equ 5

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

color db 0;10 - red, 01 - blue

distances db 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0
;distances db 12, 13, 15, 18, 22, 29, 33, 32, 56, 56, 43, 34, 35, 18, 15, 13

rotate db 0
player_x db 16,0
player_y db 16,0

indicator1 db 0;0x3A
indicator2 db 0;0x3B
terminal_input db 0;0x3C
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
start:

ldi c, BANK_RAY
ldi d, raycast
jmp change_bank

hlt

ldi c, BANK_DRAW
ldi d, draw
jmp change_bank

draw_return:
hlt


;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 2                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 2

ray_x db 0,0
ray_y db 0,0
sin_val db 0,0
cos_val db 0,0

raycast:

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

ldi a, 0
ldi b, $ + 8
ldi c, BANK_SIN
ldi d, sin
jmp change_bank
st a, sin_val
st b, sin_val + 1

ldi a, 0
ldi b, $ + 8
ldi c, BANK_SIN
ldi d, cos
jmp change_bank
st a, cos_val
st b, cos_val + 1


clr a;distance
st a, buffer
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
	
	ldi d, $ + 0;get map pixel
	st d, fn_out_index
	ldi c, BANK_MAP
	ldi d, get_point
	jmp change_bank
	
	
inc a
jmp ray_cycle
ray_cycle_end:


hlt

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 3                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 3

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
.bank 4

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

ld c, fn_out_bank
ld d, fn_out_index
jmp change_bank

map db 0b11111111, 0b11111111,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
	   0b10000000, 0b00000001,
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

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 5                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 5

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

sin_table db 0x00,0x06,0x0c,0x12,
             0x18,0x1e,0x23,0x28,
             0x2d,0x31,0x35,0x38,
             0x3b,0x3d,0x3e,0x3f,
             0x40,0x3f,0x3e,0x3d,
             0x3b,0x38,0x35,0x31,
             0x2d,0x28,0x23,0x1e,
             0x18,0x12,0x0c,0x06

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 6                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 6
