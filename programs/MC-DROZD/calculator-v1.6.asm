inc a
st a, io
jmp start ; 00h

O1 db 0x00 ; 02h
O2 db 0x00 ; 03h
R1 db 0x00, 0x00 ; 04h

str1 db "Добро пожаловать в Калькулятор\n", 0

j:
ldi b, 2
jmp unijmp

change4restart:
st b, bank
st d, c
jmp j

zeros db 0,0,0,0,0,0,0,0,0

bcd256 db 0
terminal db 0
terminal_graphics db 0
io db 1
bank db 1

OP db 0x00
REM db 0x00, 0x00
CYCL db 0x00
WYWODNAYA_STROKA db 0,0,0,0,0
NOMER_WYWODA db 0

unijmp:
st b, bank
jmp a

jmpinputoper:
ldi b, 5
ldi a, inputoper
jmp unijmp

calcstart:
ld a, OP
ldi b, 1
xor a, b
jnz calcstart2
ldi b, 5
ldi a, ad
jmp unijmp
calcstart2:
ld a, OP
ldi b, 2
xor a, b
jnz calcstart3
ldi b, 4
ldi a, sb
jmp unijmp
calcstart3:
ld a, OP
ldi b, 3
xor a, b
jnz calcstart4
ldi b, 7
ldi a, ml
jmp unijmp
calcstart4:
ld a, OP
ldi b, 4
xor a, b
jnz calcstart5
ldi b, 4
ldi a, dv
jmp unijmp
calcstart5:
ld a, OP
ldi b, 5
xor a, b
jnz calcstart6
ldi b, 4
ldi a, dv
jmp unijmp
calcstart6:
ld a, OP
ldi b, 6
xor a, b
jnz calcstart7
ldi b, 6
ldi a, pw
jmp unijmp
calcstart7:
hlt

start:
ldi c, str1
ldi b, cycl0
ldi d, terminal
cycl0:
ld a, c
test a
jz eoc0
inc c
st a, d
jmp b
eoc0:
ld a, io
test a
jz eoc0
ldi b, "0"
sub a, b
jc eoc0
mov d, a
add a, b
st d, O1
st a, terminal
input234:
ld a, io
test a
jz input234
mov d, a
ldi b, "\n"
sub a, b
jz jmpinputoper
ldi b, "0"
mov a, d
sub a, b
jc input234
ld b, O1
mov c, b
shl b
shl b
add b, c
shl b
add b, a
st b, O1
st d, terminal
jmp input234

afterstep:
ldi a, O2
st a, 0xBC
st a, 0xD1
st a, 0xD9
ldi a, calcstart
st a, 0xC9
jmp eoc0

zeros2 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

wywod:
ld c, REM
mov a, d
ldi d, "0"
add c, d
ld d, NOMER_WYWODA
ldi b, WYWODNAYA_STROKA
add b, d
st c, b
inc d
st d, NOMER_WYWODA
mov d, a
jmp wywod1

wywod1:
test d
jnz pre
ldi a, WYWODNAYA_STROKA+4
ldi c, 5
cycl2:
ld b, a
st b, terminal
dec a
dec c
jnz cycl2
ldi a, "\n"
st a, terminal
ldi a, restart1
ldi d, O1
ldi b, 1
ldi c, 0xD1
jmp change4restart
restart1:
ldi a, restart2
ldi c, 0xD9
ldi b, 1
jmp change4restart
restart2:
ldi a, restart4
ldi c, 0xBC
ldi b, 1
jmp change4restart
restart4:
ldi d, jmpinputoper
ldi c, 0xC9
ldi b, 1
ldi a, restart3
jmp change4restart
restart3:
clr c
clr d
st d, WYWODNAYA_STROKA
st d, WYWODNAYA_STROKA+1
st d, WYWODNAYA_STROKA+2
st d, WYWODNAYA_STROKA+3
st d, WYWODNAYA_STROKA+4
st d, R1+1
st d, NOMER_WYWODA
st d, REM
ldi a, eoc0
ldi b, 1
jmp unijmp
pre:
clr c
st c, REM
ldi c, 16
ldi a, pre2
ldi b, 3
jmp unijmp


zero db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

pre2:
mov a, d
clr d
st d, resbuf+1
st d, resbuf
ldi b, 10
jmp cycl1

resbuf db 0x00, 0x00
buf5 db 0x00, 0x00

art:
ldi d, 0x0A
st d, terminal
clr d
ld a, R1
st a, buf5
ld a, R1+1
st a, buf5+1
ldi b, 10
ldi c, 16
cycl1:
st c, CYCL
ld c, REM
shl d
st d, resbuf
ld d, resbuf+1
rcl d
st d, resbuf+1
ld d, resbuf
ld a, buf5
shl a
st a, buf5
ld a, buf5+1
rcl a
st a, buf5+1
rcl c
sub c, b
jns afterall
add c, b
jmp afterall2
afterall:
inc d
st d, resbuf
afterall2:
st c, REM
ld c, CYCL
dec c
jnz cycl1
ld d, resbuf+1
st d, buf5+1
ld d, resbuf
st d, buf5
ldi b, 2
ldi a, wywod
jmp unijmp



zeros3 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


REMextend db 0x00, 0x00
CYCL5 db 0x00

dv:
ld a, O1
ld b, O2
ldi c, 8
clr d
test b
jnz cycl4
ldi a, "r"
st a, WYWODNAYA_STROKA
st a, WYWODNAYA_STROKA+1
ldi a, "e"
st a, WYWODNAYA_STROKA+2
ldi b, 2
ldi a, wywod1
jmp unijmp
cycl4:
st c, CYCL5
ld c, REMextend
shl d
shl a
rcl c
jnc neoc42
st c, REMextend
clr c
inc c
st c, REMextend+1
ld c, REMextend
neoc42:
sub c, b
jns afterall3
st c, REMextend
ld c, REMextend+1
test c
jz neoc43
dec c
jmp afterall3
neoc43:
ld c, REMextend
add c, b
jmp afterall4
afterall3:
inc d
afterall4:
st c, REMextend
ld c, CYCL5
dec c
jnz neoc4
st d, R1
ld a, OP
ldi b, 5
sub b, a
jnz neoc44
ld c, REMextend
st c, R1
neoc44:
clr c
st c, REMextend
st c, REMextend+1
st c, CYCL5
ldi b, 3
ldi a, art
jmp unijmp
neoc4:
jmp cycl4

sb:
ld a, O1
ld b, O2
sub a, b
st a, R1
jnc sb2
clr a
dec a
st a, R1+1
sb2:
ldi a, art
ldi b, 3
jmp unijmp

zeros5 db 0,0,0,0,0,0,0,0,0

jmpafterstep:
ldi b, 1
ldi a, afterstep
jmp unijmp

inputoper:
ld a, io
mov d, a
test a
jz inputoper
ldi b, "+"
xor a, b
jnz nextstep0
ldi a, 1
st a, OP
st d, terminal
jmp jmpafterstep
nextstep0:
xor a, b
ldi b, "-"
xor a, b
jnz nextstep1
ldi a, 2
st a, OP
st d, terminal
jmp jmpafterstep
nextstep1:
xor a, b
ldi b, "*"
xor a, b
jnz nextstep2
ldi a, 3
st a, OP
st d, terminal
jmp jmpafterstep
nextstep2:
xor a, b
ldi b, "/"
xor a, b
jnz nextstep3
ldi a, 4
st a, OP
st d, terminal
jmp jmpafterstep
nextstep3:
xor a, b
ldi b, "%"
xor a, b
jnz nextstep4
ldi a, 5
st a, OP
st d, terminal
jmp jmpafterstep
nextstep4:
xor a, b
ldi b, "^"
xor a, b
jnz nextstep5
ldi a, 6
st a, OP
st d, terminal
jmp jmpafterstep
nextstep5:
jmp inputoper

ad:
ld a, O1
ld b, O2
add a, b
st a, R1
jnc ad2
clr a
inc a
st a, R1+1
ad2:
ldi a, art
ldi b, 3
jmp unijmp

zeros6 db 0,0,0,0,0,0,0,0,0,0,0,0

errormsg db "NOT SUPPORTED", 0

pw:
ldi c, errormsg
ldi b, cycl9
ldi d, terminal
cycl9:
ld a, c
test a
jz eoc9
inc c
st a, d
jmp b
eoc9:
clr c
clr d
ldi a, art
ldi b, 3
jmp unijmp

zeros9 db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


Rdub db 0x00, 0x00
O1dub db 0x00, 0x00



ml:
ld a, O1
ld b, O2
st a, O1dub
clr c
ldi d, 8
cycl3:
shr b
jnc neoc3
add c, a
st c, Rdub
ld c, Rdub+1
ld a, O1dub+1
adc c, a
ld a, O1dub
st c, Rdub+1
ld c, Rdub
neoc3:
shl a
st a, O1dub
ld a, O1dub+1
rcl a
st a, O1dub+1
ld a, O1dub
dec d
jnz cycl3
st c, R1
ld c, Rdub+1
st c, R1+1
clr a
st a, Rdub+1
st a, O1dub+1
ldi a, art
ldi b, 3
jmp unijmp
