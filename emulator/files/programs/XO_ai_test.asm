COLORED equ 0b00110101

BANK_MAIN equ 1
BANK_LINE equ 2

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                       ОБЩАЯ ОБЛАСТЬ                         W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 0


ldi a, display
ldi c, display_blue
ldi b, 32

clear:
st d, a
st d, c

inc a
inc c
dec b
jnz clear

jmp start

void db 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0

;###############################################################
change_bank:;переход между банками. c - индекс банка, d - индекс перехода
st c, bank
jmp d
;###############################################################

buffer db 0,0,0,0		 

fn_output_index db 0,0

field db 0,0,0,;1 - X, 10 - O
		 0,0,0,
		 0,0,0

indicator1 db 0;0x3A
indicator2 db 0;0x3B
terminal_input db 0;0x3C
terminal_graphics db 0;0x3D
connect db COLORED;0x3E
bank db 1;0x3F

display db          0b00000000, 0b00000000,
                    0b01001000, 0b00000000,
                    0b00110000, 0b00000000,
                    0b00110000, 0b00000000,
                    0b01001000, 0b00000000,
                    0b00000111, 0b11100000,
                    0b00000110, 0b01100000,
                    0b00000101, 0b10100000,
                    0b00000101, 0b10100000,
                    0b00000110, 0b01100000,
                    0b00000111, 0b11100000,
                    0b00000010, 0b01000000,
                    0b00000001, 0b10000000,
                    0b00000001, 0b10000000,
                    0b00000010, 0b01000000,
                    0b00000000, 0b00000000

display_blue db     0b00000000, 0b00000000,
                    0b00000000, 0b00001100,
                    0b00000000, 0b00010010,
                    0b00000000, 0b00010010,
                    0b00000000, 0b00001100,
                    0b00000111, 0b11100000,
                    0b00000100, 0b00100000,
                    0b00000100, 0b00100000,
                    0b00000100, 0b00100000,
                    0b00000100, 0b00100000,
                    0b00000111, 0b11100000,
                    0b00110000, 0b00001100,
                    0b01001000, 0b00010010,
                    0b01001000, 0b00010010,
                    0b00110000, 0b00001100,
                    0b00000000, 0b00000000


;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 1                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 1
start:

ldi a, 20
ldi b, $ + 8
ldi c, BANK_LINE
ldi d, test_lines
jmp change_bank

hlt

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 2                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 2

test_lines:;a - control sum, b - output
st a, buffer
st b, fn_output_index

ldi a, 7
st a, buffer + 1

ldi a, lines + 21

test_lines_cycle:

;###############################################################
;a - line index
ld d, a;cell #1
ld c, d

inc a
ld d, a;cell #2
ld d, d
add c, d

inc a
ld d, a;cell #3
ld d, d
add c, d

ld b, buffer
sub b, c
jnz continue


dec a
dec a
ldi b, 3
find_void_cycle:

ld c, a
ld d, c
test d
jz return_void_pos

inc a
dec b
jnz find_void_cycle


return_void_pos:
ldi a, field
sub c, a
ldi a, addr_to_coord
add c, a
ld a, c

ldi b, 0b0011;b - ypos
and b, a
shr a;a - xpos
shr a
jmp test_lines_find


continue:
;###############################################################

ld a, buffer + 1
dec a
js test_lines_output
st a, buffer + 1

mov b, a
shl a
add a, b
ldi b, lines
add a, b
jmp test_lines_cycle

test_lines_output:
ldi a, 255
test_lines_find:
ldi c, BANK_MAIN
ld d, fn_output_index
jmp change_bank

lines db field,   field+1, field+2,
		 field+3, field+4, field+5,
		 field+6, field+7, field+8,
		 field,   field+3, field+6,
		 field+1, field+4, field+7,
		 field+2, field+5, field+8,
		 field,   field+4, field+8,
		 field+2, field+4, field+6
		 
addr_to_coord db 0b0000, 0b0100, 0b1000,
				 0b0001, 0b0101, 0b1001,
				 0b0010, 0b0110, 0b1010

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 3                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 3



.bank 4
