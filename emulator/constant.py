import pygame
pygame.init()

emuname = "Emulator v1.3"

W = pygame.display.Info().current_w
H = pygame.display.Info().current_h

font80 = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 80)
font48 = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 48)
font32 = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 32)
font16 = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 16)
font15 = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 15)
font14 = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 14)
progfont = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 13)
font_alert = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 32)

A = 0
B = 1
C = 2
D = 3

z = 0
s = 1
c = 2
o = 3

texture = pygame.image.load("files/fonts/font.png")

sound = pygame.mixer.Sound("files/sound/Powerup5.wav")

opcodes = [
    "nop",    "hlt",     "ssp",     "jmp",     "jmp a",   "jmp b",  "jmp c",   "jmp d",   "jz",      "js",      "jc",     "jo",      "jnz",     "jns",     "jnc",     "jno",
    "jz a",   "js a",    "jc a",    "jo a",    "jz b",    "js b",   "jc b",    "jo b",    "jz c",    "js c",    "jc c",   "jo c",    "jz d",    "js d",    "jc d",    "jo d",
    "jnz a",  "jns a",   "jnc a",   "jno a",   "jnz b",   "jns b",  "jnc b",   "jno b",   "jnz c",   "jns c",   "jnc c",  "jno c",   "jnz d",   "jns d",   "jnc d",   "jno d",
    "st a",   "st b,a",  "st c,a",  "st d,a",  "st a,b",  "st b",   "st c,b",  "st d,b",  "st a,c",  "st b,c",  "st c",   "st d,c",  "st a,d",  "st b,d",  "st c,d",  "st d",
    "ld a,a", "ld b,a",  "ld c,a",  "ld d,a",  "ld a,b",  "ld b,b", "ld c,b",  "ld d,b",  "ld a,c",  "ld b,c",  "ld c,c", "ld d,c",  "ld a,d",  "ld b,d",  "ld c,d",  "ld d,d",
    "ld a",   "ld b",    "ld c",    "ld d",    "ldi a",   "ldi b",  "ldi c",   "ldi d",   0,         0,         0,        0,         0,         0,         0,         0,
    "inc a",  "add b,a", "add c,a", "add d,a", "add a,b", "inc b",  "add c,b", "add d,b", "add a,c", "add b,c", "inc c",  "add d,c", "add a,d", "add b,d", "add c,d", "inc d",
    "dec a",  "sub b,a", "sub c,a", "sub d,a", "sub a,b", "dec b",  "sub c,b", "sub d,b", "sub a,c", "sub b,c", "dec c",  "sub d,c", "sub a,d", "sub b,d", "sub c,d", "dec d",
    "not a",  "adc b,a", "adc c,a", "adc d,a", "adc a,b", "not b",  "adc c,b", "adc d,b", "adc a,c", "adc b,c", "not c",  "adc d,c", "adc a,d", "adc b,d", "adc c,d", "not d",
    "neg a",  "sbb b,a", "sbb c,a", "sbb d,a", "sbb a,b", "neg b",  "sbb c,b", "sbb d,b", "sbb a,c", "sbb b,c", "neg c",  "sbb d,c", "sbb a,d", "sbb b,d", "sbb c,d", "neg d",
    "clr a",  "mov b,a", "mov c,a", "mov d,a", "mov a,b", "clr b",  "mov c,b", "mov d,b", "mov a,c", "mov b,c", "clr c",  "mov d,c", "mov a,d", "mov b,d", "mov c,d", "clr d",
    "test a", "and b,a", "and c,a", "and d,a", "and a,b", "test b", "and c,b", "and d,b", "and a,c", "and b,c", "test c", "and d,c", "and a,d", "and b,d", "and c,d", "test d",
    "rcl a",  "or b,a",  "or c,a",  "or d,a",  "or a,b",  "rcl b",  "or c,b",  "or d,b",  "or a,c",  "or b,c",  "rcl c",  "or d,c",  "or a,d",  "or b,d",  "or c,d",  "rcl d",
    "rcr a",  "xor b,a", "xor c,a", "xor d,a", "xor a,b", "rcr b",  "xor c,b", "xor d,b", "xor a,c", "xor b,c", "rcr c",  "xor d,c", "xor a,d", "xor b,d", "xor c,d", "rcr d",
    "shl a",  "shl b",   "shl c",   "shl d",   "shr a",   "shr b",  "shr c",   "shr d",   "sar a",   "sar b",   "sar c",  "sar d",   "rnd a",   "rnd b",   "rnd c",   "rnd d",
    0,        "cmp b,a", "cmp c,a", "cmp d,a", "cmp a,b", 0,        "cmp c,b", "cmp d,b", "cmp a,c", "cmp b,c", 0,        "cmp d,c", "cmp a,d", "cmp b,d", "cmp c,d", 0
]