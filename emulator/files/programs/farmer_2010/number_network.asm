COLORED equ 0b00110100

KEY_UP equ 0x12
KEY_RIGHT equ 0x13
KEY_DOWN equ 0x14
KEY_LEFT equ 0x11
KEY_SPACE equ 0x20
KEY_ENTER equ 0x0A

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                       ОБЩАЯ ОБЛАСТЬ                         W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW

jmp start

draw_point_from_mem:
ld a, x
ld b, y
draw_point:;a - x, b - y, c - адрес дисплея, d - возврат

st c, buffer

;позиция байта
shl b
shl b

ldi c, 0b00000100
and c, a
jz plus_1_end
inc b
plus_1_end:
ld c, buffer
add b, c


;битовая маска
ldi c, 0b00000011
and a, c

ldi c, 0b11000000
rot_cycle:
test a
jz stop_rot

shr c
shr c
dec a
jmp rot_cycle
stop_rot:
mov a, c

ld c, b
xor c, a
st c, b
inc b
inc b
ld c, b
xor c, a
st c, b


jmp d

;###############################################################
change_bank:;переход между банками. c - индекс банка, d - индекс перехода
st c, bank
jmp d
;###############################################################

buffer db 0,0,0
fn_out_index db 0

rotate_position db 255,;left
				   255,;up
				   1,  ;right
				   1   ;down

x db 0
y db 0

void db 0,0,0

indicator1 db 0;0x3A
indicator2 db 0;0x3B
terminal_input db 0;0x3C
terminal_graphics db 0;0x3D
connect db COLORED;0x3E
bank db 1;0x3F

display db      0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
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
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000,
				0b00000000, 0b00000000

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 1                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW	
.bank

cycle:

ld c, connect

ldi d, KEY_SPACE
sub d, c
jnz skip_set

ldi c, display_blue
ldi d, cycle
jmp draw_point_from_mem

skip_set:

ldi d, 0x11
sub c, d

ldi d, 3
sub d, c
jc cycle

ldi a, x
ldi d, 0b00000001
and d, c
add a, d
ld b, a

ldi d, rotate_position
add c, d

ld d, c
add b, d
js cycle
ldi d, 8
sub d, b
jz cycle

st a, buffer + 1
st b, buffer + 2
ldi c, display
ldi d, $ + 4
jmp draw_point_from_mem

ld a, buffer + 1
ld b, buffer + 2
st b, a

start:
ldi c, display
ldi d, cycle
jmp draw_point_from_mem