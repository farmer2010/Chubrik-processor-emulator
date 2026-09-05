from random import randint as rand
from compiler import *
from compiler_v2 import *
import pygame
pygame.init()

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

def get_symbol(ind, scale=8):
    img = pygame.Surface((6, 8))
    x = (ind % 16) * 6
    y = (ind // 16) * 8
    img.blit(texture, (-x, -y))
    img = pygame.transform.scale(img, (6 * scale, 8 * scale))
    return(img)

def generate_symbol(data, scale=8):
    img = pygame.Surface((6, 8))
    img.fill((255, 255, 255))
    for x in range(6):
        for y in range(8):
            if data[x] & (2 ** y):
                pygame.draw.rect(img, (0, 0, 0), (x, y, 1, 1))
    img = pygame.transform.scale(img, (6 * scale, 8 * scale))
    return (img)


font = [get_symbol(i) for i in range(256)]#шрифт для консоли

enabled_symbols = [
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "+", "-", "*", "/", "=", "_", "(", ")", "[", "]", "{", "}", "!", "@", "#", "$", "%", "^", "&", "`", "~", "№", ";", "?", ":", ".", ",", "'", '"', "\\", "<", ">",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я",
    "а", "б", "в", "г", "д", "е", "ё", "ж", "з", "и", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ъ", "ы", "ь", "э", "ю", "я",
    " ", chr(127)#delete
]

def dec_to_bin(num):
    out = ""
    for i in range(8):
        if num > 2 ** (7 - i):
            out += "1"
        else:
            out += "0"
    return(out)

def bin_to_dec(num):
    out = 0
    for i in range(len(num)):
        out += int(num[i]) * 2 ** (len(num) - 1 - i)
    return(out)

def to_signed(x):
    if x > 127:
        return(x - 256)
    else:
        return(x)

def to_unsigned(x):
    if x < 0:
        return(x + 256)
    else:
        return(x)

class Emulator():
    def __init__(self, additional_banks=255, console_w=12, console_h=4):
        self.console_w = console_w
        self.console_h = console_h
        self.add_banks_count = additional_banks
        self.bank = 1
        self.memory = [0 for i in range(128 * (1 + additional_banks))]
        #память. область с 0 по 127 - общая, не является банком. Счет банков идет с 1, число 0 подключает банк 1.
        #память общая, содержит 32 кб данных. Каждый блок содержит 128 байт.
        self.console = [[font[0] for x in range(console_w)]for y in range(console_h)]#консоль
        self.console_index = 0#положение курсора консоли
        self.console_buffer = []#когда тут накопятся 6 байт, в консоль выведется графический символ
        self.bell = 0#состояние звонка
        #
        self.reg = [0, 0, 0, 0]#регистры
        self.flags = [0, 0, 0, 0]#флаги
        #
        self.index = 0#program counter
        #
        self.enable_display = 0#0 - нет, 1 - монохромный, 2 - цветной
        self.enable_indicator = 0#0 - нет, 1 - беззнаковый, 2 - знаковый
        self.enable_console = 0#0 - выкл, 1 - вкл
        #
        #
        #
        self.indicator_b1 = 0#цифровой индикатор - байт 1(младший)
        self.indicator_b2 = 0#байт 2(старший)
        #
        self.pixel_size = 32
        self.display = pygame.Surface((16 * self.pixel_size, 16 * self.pixel_size))#текстура дисплея
        self.display.fill((255, 255, 255))
        self.colors = [[[0, 0] for y in range(16)]for x in range(16)]#массив цветов дисплея [red, blue]
        self.update_colors = [[0 for y in range(16)]for x in range(16)]#нужно ли перерисовывать пиксель
        #
        self.speed = 4
        #
        file = open("files/programs/XO_pvp.asm", encoding="utf-8")#загрузка программы
        txt = file.read()
        file.close()
        res = compile(txt)
        code = res[0]
        print(f"\ncode length: {len(code)}")
        print(res[1])
        for i in range(len(code)):  #во время загрузки программы можно переключать режим работы дисплея,
            self.memory[i] = code[i]#писать данные на дисплей, но нельзя переключать банки памяти
            if i >= 0x3A and i <= 0x7F and i != 0x3D and i != 0x3C:
                self.update_ports(i, code[i])
    #
    #ВВОД/ВЫВОД
    #

    def write(self, ind, value):
        if ind < 128:
            self.memory[ind] = value
            if ind >= 0x3A:
                self.update_ports(ind, value)
            if ind == 0x3F:
                self.bank = max(value, 1)
        else:
            self.memory[ind + (self.bank - 1) * 128] = value#если индекс выходит за общую область, пишем данные в нужный банк

    def read(self, ind):
        if ind < 128:
            if ind == 0x3E:#при считывании с порта 3E он обнуляется, потому что в него идет ввод с клавиатуры
                d = self.memory[ind]
                self.memory[ind] = 0
                return(d)
            return(self.memory[ind])
        else:
            return(self.memory[ind + (self.bank - 1) * 128])

    def update_ports(self, ind, value):
        if ind == 0x3A and self.enable_indicator:
            self.indicator_b1 = value
        elif ind == 0x3B and self.enable_indicator:
            self.indicator_b2 = value
        elif ind == 0x3E:
            if value & 16 > 0:#подключение дисплея
                if value & 32 > 0:
                    self.enable_display = 2
                else:
                    self.enable_display = 1
            else:
                self.enable_display = 0
            #
            if value & 4 > 0:#подключение индикатора
                if value & 8 > 0:
                    self.enable_indicator = 2
                else:
                    self.enable_indicator = 1
            else:
                self.enable_indicator = 0
            #
            self.enable_console = value % 2#подключение консоли
        elif ind == 0x3C and self.enable_console:
            self.bell = not self.bell
            if value >= 32:
                self.console[-1][self.console_index] = font[value]
                #
                if value != 127:
                    self.console_index += 1
                    #
                    if self.console_index == self.console_w:
                        self.console_index = 0
                        self.console = self.console[1:]
                        self.console.append([font[0] for i in range(self.console_w)])
            elif value == 0x07:
                if self.bell == 1:
                    sound.play()
            elif value == 0x08:
                if self.console_index > 0:
                    self.console_index -= 1
                    self.console[-1][self.console_index] = font[0]
            elif value == 0x09:
                self.console_index = min(self.console_w - 1, (self.console_index + 4) // 4 * 4)
            elif value == 0x0A:
                self.console_index = 0
                self.console = self.console[1:]
                self.console.append([font[0] for i in range(self.console_w)])
            elif value == 0x0D:
                self.console_index = 0
            elif value == 0x0C:
                self.console_index = 0
                self.console = [[font[0] for x in range(self.console_w)] for y in range(self.console_h)]  # консоль
            elif value == 0x11:
                self.console_index = max(0, self.console_index - 1)
            elif value == 0x13:
                self.console_index = min(self.console_w - 1, self.console_index + 1)
        elif ind == 0x3D:
            self.console_buffer.append(value)
            if len(self.console_buffer) == 6:
                if self.enable_console:
                    self.console[-1][self.console_index] = generate_symbol(self.console_buffer)
                    self.console_index += 1
                    #
                    if self.console_index == self.console_w:
                        self.console_index = 0
                        self.console = self.console[1:]
                        self.console.append([font[0] for i in range(self.console_w)])
                #
                self.console_buffer = []
        elif 0x40 <= ind <= 0x7F:
            self.write_display(value, ind)

    def write_display(self, byte, ind):
        c = 0#red
        if self.enable_display == 0:
            return
        if self.enable_display == 1 and ind >= 0x60:
            return
        if ind >= 0x60:
            c = 1
            ind -= 0x60
        else:
            ind -= 0x40
        for i in range(8):
            x = (ind % 2) * 8 + i
            y = ind // 2
            if self.enable_display == 2:
                self.colors[x][y][c] = int(byte & (2 ** (7 - i)) > 0)
                self.update_colors[x][y] = 1
            else:
                self.colors[x][y][0] = int(byte & (2 ** (7 - i)) > 0)
                self.colors[x][y][1] = int(byte & (2 ** (7 - i)) > 0)
                self.update_colors[x][y] = 1

    #
    #ОБНОВЛЕНИЕ
    #

    def update_display(self):#обновить текстуру дисплея
        for x in range(16):
            for y in range(16):
                if self.update_colors[x][y]:
                    if self.colors[x][y][0] == 0 and self.colors[x][y][1] == 0:
                        pygame.draw.rect(self.display, (255, 255, 255), (x * 32, y * 32, 32, 32))
                    elif self.colors[x][y][0] == 1 and self.colors[x][y][1] == 0:
                        pygame.draw.rect(self.display, (255, 0, 0), (x * 32, y * 32, 32, 32))
                    elif self.colors[x][y][0] == 0 and self.colors[x][y][1] == 1:
                        pygame.draw.rect(self.display, (76, 128, 255), (x * 32, y * 32, 32, 32))
                    elif self.colors[x][y][0] == 1 and self.colors[x][y][1] == 1:
                        pygame.draw.rect(self.display, (165, 64, 128), (x * 32, y * 32, 32, 32))
                    self.update_colors[x][y] = 0

    def update(self, events):#обработка команд
        b = 0
        for event in events:
            if event.type == pygame.KEYDOWN:
                if event.unicode in enabled_symbols:
                    self.memory[0x3E] = int.from_bytes(event.unicode.encode("cp1251"))
                if event.key == pygame.K_LEFT:
                    self.memory[0x3E] = 0x11
                elif event.key == pygame.K_UP:
                    self.memory[0x3E] = 0x12
                elif event.key == pygame.K_RIGHT:
                    self.memory[0x3E] = 0x13
                elif event.key == pygame.K_DOWN:
                    self.memory[0x3E] = 0x14
                elif event.key == pygame.K_RETURN:
                    self.memory[0x3E] = 0x0A
                elif event.key == pygame.K_TAB:
                    self.memory[0x3E] = 0x09
                if event.key == pygame.K_BACKSPACE:
                    self.memory[0x3E] = 0x08
                    b = 1
        #
        #
        #
        counter = 0
        for i in range(self.speed):
            counter += 1
            #
            opcode = self.read(self.index)
            oper = self.read((self.index + 1) % 256)
            hor = opcode & 0x0F#колонки в таблице опкодов
            vert = (opcode & 0xF0) >> 4#строки в таблице опкодов
            #
            #X и Y - не X и Y из документации. X - модуль по строкам таблицы(abcd abcd abcd abcd)
            #Y - целочисленное деление по строкам таблицы(aaaa bbbb cccc dddd)
            X = (opcode & 0x0F) % 4
            Y = (opcode & 0x0F) // 4
            F = (opcode & 0x0F) % 4#необходимый флаг
            #
            #счетчик увеличивается в функции операции на 1 или 2 в зависимости от наличия операнда
            if opcode == 0x00:
                self.index = (self.index + 1) % 256
            elif opcode == 0x01:
                pass#stop
            elif opcode == 0x02:
                if b:
                    self.index = (self.index + 1) % 256
                    b = 0
                    break
            elif opcode == 0x03:
                self.jmp(oper)
            elif 0x04 <= opcode <= 0x07:
                self.jmpx(self.reg[X])
            elif 0x08 <= opcode <= 0x0B:
                self.jf(self.flags[F], oper)
            elif 0x0C <= opcode <= 0x0F:
                self.jnf(self.flags[F], oper)
            elif 0x10 <= opcode <= 0x1F:
                self.jfx(self.flags[F], self.reg[Y])
            elif 0x20 <= opcode <= 0x2F:
                self.jnfx(self.flags[F], self.reg[Y])
            elif 0x30 <= opcode <= 0x3F:
                if hor % 5 == 0:
                    self.st(self.reg[X], oper)
                else:
                    self.stx(self.reg[X], self.reg[Y])
            elif 0x40 <= opcode <= 0x4F:
                self.reg[X] = self.ldx(self.reg[Y])
            elif 0x50 <= opcode <= 0x53:
                self.reg[X] = self.ld(oper)
            elif 0x54 <= opcode <= 0x57:
                self.reg[X] = self.ldi(oper)
            elif 0x60 <= opcode <= 0xDF:
                if hor % 5 == 0:
                    if vert == 6:
                        self.reg[X] = self.inc(self.reg[X])
                    elif vert == 7:
                        self.reg[X] = self.dec(self.reg[X])
                    elif vert == 8:
                        self.reg[X] = self.f_not(self.reg[X])
                    elif vert == 9:
                        self.reg[X] = self.neg(self.reg[X])
                    elif vert == 10:
                        self.reg[X] = self.clr()
                    elif vert == 11:
                        self.test(self.reg[X])
                    elif vert == 12:
                        self.reg[X] = self.rcl(self.reg[X])
                    elif vert == 13:
                        self.reg[X] = self.rcr(self.reg[X])
                else:
                    if vert == 6:
                        self.reg[X] = self.add(self.reg[X], self.reg[Y])
                    elif vert == 7:
                        self.reg[X] = self.sub(self.reg[X], self.reg[Y])
                    elif vert == 8:
                        self.reg[X] = self.adc(self.reg[X], self.reg[Y])
                    elif vert == 9:
                        self.reg[X] = self.sbb(self.reg[X], self.reg[Y])
                    elif vert == 10:
                        self.reg[X] = self.mov(self.reg[Y])
                    elif vert == 11:
                        self.reg[X] = self.f_and(self.reg[X], self.reg[Y])
                    elif vert == 12:
                        self.reg[X] = self.f_or(self.reg[X], self.reg[Y])
                    elif vert == 13:
                        self.reg[X] = self.f_xor(self.reg[X], self.reg[Y])
                #
            elif 0xE0 <= opcode <= 0xE3:
                self.reg[X] = self.shl(self.reg[X])
            elif 0xE4 <= opcode <= 0xE7:
                self.reg[X] = self.shr(self.reg[X])
            elif 0xE8 <= opcode <= 0xEB:
                self.reg[X] = self.sar(self.reg[X])
            elif 0xEC <= opcode <= 0xEF:
                self.reg[X] = self.rnd()
            else:
                self.index = (self.index + 1) % 256
        return(counter)#возвращает количество пройденных шагов

    #
    #ПРЕСЕТЫ ОПЕРАЦИЙ
    #

    #управляющие инструкции
    def ld(self, oper):#возвращает значение по адресу oper из памяти
        self.index = (self.index + 2) % 256
        return(self.read(oper))

    def ldx(self, Y):
        self.index = (self.index + 1) % 256
        return(self.read(Y))

    def ldi(self, oper):#возвращает операнд
        self.index = (self.index + 2) % 256
        return(oper)

    def st(self, X, oper):
        self.index = (self.index + 2) % 256
        self.write(oper, X)

    def stx(self, X, Y):
        self.index = (self.index + 1) % 256
        self.write(Y, X)

    def jmp(self, oper):
        self.index = oper

    def jmpx(self, X):
        self.index = X

    def jf(self, F, oper):
        if F:
            self.index = oper
        else:
            self.index = (self.index + 2) % 256

    def jnf(self, F, oper):
        if not F:
            self.index = oper
        else:
            self.index = (self.index + 2) % 256

    def jfx(self, F, X):
        if F:
            self.index = X
        else:
            self.index = (self.index + 1) % 256

    def jnfx(self, F, X):
        if not F:
            self.index = X
        else:
            self.index = (self.index + 1) % 256

    #вычислительные инструкции
    def clr(self):
        self.index = (self.index + 1) % 256
        return(0)

    def mov(self, Y):
        self.index = (self.index + 1) % 256
        return(Y)

    def f_and(self, X, Y):
        out = X & Y
        self.flags[z] = out == 0
        self.flags[s] = out > 127
        self.index = (self.index + 1) % 256
        return(out)

    def f_or(self, X, Y):
        out = X | Y
        self.flags[z] = out == 0
        self.flags[s] = out > 127
        self.index = (self.index + 1) % 256
        return(out)

    def f_xor(self, X, Y):
        out = X ^ Y
        self.flags[z] = out == 0
        self.flags[s] = out > 127
        self.index = (self.index + 1) % 256
        return(out)

    def add(self, X, Y):
        out = X + Y
        self.flags[z] = out % 256 == 0
        self.flags[s] = out % 256 > 127
        self.flags[c] = out > 255 or out < 0
        self.flags[o] = not (-128 <= (to_signed(X) + to_signed(Y)) <= 127)
        self.index = (self.index + 1) % 256
        return(out % 256)

    def adc(self, X, Y):
        out = X + Y + self.flags[c]
        self.flags[z] = out % 256 == 0
        self.flags[s] = out % 256 > 127
        self.flags[c] = out > 255 or out < 0
        self.flags[o] = not (-128 <= (to_signed(X) + to_signed(Y) + self.flags[c]) <= 127)
        self.index = (self.index + 1) % 256
        return(out % 256)

    def sub(self, X, Y):
        out = X - Y
        self.flags[z] = out % 256 == 0
        self.flags[s] = out % 256 > 127
        self.flags[c] = out < 0
        self.flags[o] = not (-128 <= (to_signed(X) - to_signed(Y)) <= 127)
        self.index = (self.index + 1) % 256
        return(out % 256)

    def sbb(self, X, Y):
        out = X - Y - self.flags[c]
        self.flags[z] = out % 256 == 0
        self.flags[s] = out % 256 > 127
        self.flags[c] = out < 0
        self.flags[o] = not (-128 <= (to_signed(X) - to_signed(Y) - self.flags[c]) <= 127)
        self.index = (self.index + 1) % 256
        return(out % 256)

    def test(self, X):
        self.flags[z] = X == 0
        self.flags[s] = X > 127
        self.index = (self.index + 1) % 256
        return(X)

    def inc(self, X):
        out = X + 1
        self.flags[z] = out % 256 == 0
        self.flags[s] = out % 256 > 127
        self.index = (self.index + 1) % 256
        return(out % 256)

    def dec(self, X):
        out = X - 1
        self.flags[z] = out % 256 == 0
        self.flags[s] = out % 256 > 127
        self.index = (self.index + 1) % 256
        return(out % 256)

    def f_not(self, X):
        out = ~X & 0xFF
        self.flags[z] = out == 0
        self.flags[s] = out % 256 > 127
        self.index = (self.index + 1) % 256
        return(out)

    def neg(self, X):
        out = 0 - X
        self.flags[z] = out % 256 == 0
        self.flags[s] = out % 256 > 127
        self.flags[c] = out < 0
        self.flags[o] = not (-128 <= (0 - to_signed(X)) <= 127)
        self.index = (self.index + 1) % 256
        return(out % 256)

    def rnd(self):
        out = rand(0, 255)
        self.flags[z] = out == 0
        self.flags[s] = out % 256 > 127
        self.index = (self.index + 1) % 256
        return(out)

    def shl(self, X):
        out = X << 1
        self.flags[z] = out == 0
        self.flags[s] = out % 256 > 127
        self.flags[c] = out > 255 or out < 0
        self.index = (self.index + 1) % 256
        return(out % 256)

    def shr(self, X):
        new_c = X & 1
        out = X >> 1
        self.flags[z] = out == 0
        self.flags[s] = out > 127
        self.flags[c] = new_c
        self.index = (self.index + 1) % 256
        return(out % 256)

    def sar(self, X):
        new_c = X & 1
        left = X & 0x80
        out = (X >> 1) | left
        self.flags[z] = out == 0
        self.flags[s] = out > 127
        self.flags[c] = new_c
        self.index = (self.index + 1) % 256
        return(out % 256)

    def rcl(self, X):
        out = (X << 1) | self.flags[c]
        self.flags[z] = out == 0
        self.flags[s] = out % 256 > 127
        self.flags[c] = out > 255 or out < 0
        self.index = (self.index + 1) % 256
        return(out % 256)

    def rcr(self, X):
        new_c = X & 1
        out = (X >> 1) | (self.flags[c] * 0x80)
        self.flags[z] = out == 0
        self.flags[s] = out > 127
        self.flags[c] = new_c
        self.index = (self.index + 1) % 256
        return(out % 256)