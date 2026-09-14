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

field db 10,0,10,;1 - X, 10 - O
		 0,0,0,
		 10,0,0

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

ldi a, lines
ldi b, 20
ldi d, $ + 10
st d, fn_output_index
ldi c, BANK_LINE
ldi d, test_line
jmp change_bank

hlt

;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
;W                           БАНК 2                            W
;WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW
.bank 2

test_line:;a - line index, b - control sum, d - output

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

sub b, c
jnz return


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
ld c, c

ldi b, 0b0011;b - ypos
and b, c
ldi a, 0b1100;a - xpos
and a, c
shr a
shr a
jmp test_line_output


return:
clr a
dec a
test_line_output:
;ldi c, BANK_MAIN
ld d, fn_output_index
;jmp change_bank
jmp d


test_O_lines:
ldi a, 8
st a, buffer
ldi a, lines
st a, buffer + 1

test_O_lines_cycle:

ld a, buffer
dec a
st a, buffer
jnz test_O_lines_cycle


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
