KEY_RIGHT equ 0x13 ;код клавиши "вправо"
KEY_UP equ 0x12 ;код клавиши "вверх"
KEY_LEFT equ 0x11 ;код клавиши "влево"
KEY_DOWN equ 0x14 ;код клавиши "вниз"
ldi d, display_r ;начало дисплея
ldi b, clear_loop ;сохраняем адрес цикла для ускорения работы
;регистр a пустой
clear_loop: ;цикл для очистки дисплея
  st a, d ;стираем байт на дисплее
  inc d ;переходим к следующему байту
  jns b ;если не вышли за пределы дисплея, продолжаем очистку
ldi a, 0b00011100 ;выводим змейку
st a, 0x7a
ld a, head_pos ;выводим голову змейки
st a, 0x5a
;регистр c содержит 0 (1-й банк)
;регистр d содержит адрес перехода (0x80)
set_bank:
  st c, bank ;сохраняем банк
  jmp d ;переходим к следующему блоку
;после съедения яблока переходим к генерации нового
other_bank:
  clr c
  st c, bank
  jmp apple_random
void db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
next db 0 ;переход после сохранения направления головы
save db 0 ;адрес для хранения важных значений
last_cell_adress db snake ;адрес клеток змейки
last_cell_pos db 4 ;количество итераций для выравнивания направления клетки змейки
last_key db KEY_RIGHT ;последнее направление змейки (изначально вправо)
lock_key db KEY_LEFT ;запретная клавиша (противоположна направлению змейки)
tail_adress db 0x7a ;адрес хвоста на дисплее
tail_pos db 0b00010000 ;положение в байте хвоста на дисплее
head_adress db 0x7a ;адрес головы на дисплее
head_pos db 0b00000100 ;положение в байте головы на дисплее
apple_adress db 0 ;адрес яблока на дисплее
apple_pos db 0 ;положение в байте яблока на дисплее
score db 2 ;длина (очки)
numX256 db 0
terminal db 0 ;вывод символов
terminal_art db 0 ;вывод графики
in_out db 0b00110101 ;ввод-вывод (подключаем цветной дисплей,
;цифровой индикатор и терминал)
bank db 0 ;банк
;заставка
display_r   db  0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00001000, 0b00000000,
                0b00000000, 0b00000100,
                0b00100000, 0b00001000,
                0b11000000, 0b00011110,
                0b01000000, 0b00101111,
                0b00000000, 0b00111111,
                0b00000000, 0b00111111,
                0b00000000, 0b00011110,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000 
display_b   db  0b00000000, 0b00000000,
                0b00000000, 0b00000000,
                0b00011100, 0b00000000,
                0b00111111, 0b00000000,
                0b00111111, 0b10000100,
                0b00111101, 0b10001000,
                0b11000001, 0b10000000,
                0b01001111, 0b10000000,
                0b00011111, 0b00000000,
                0b00110000, 0b00000000,
                0b00110000, 0b00000000,
                0b00111111, 0b10000000,
                0b00011111, 0b11000000,
                0b00000000, 0b11111000,
                0b00000000, 0b00000000,
                0b00000000, 0b00000000
;BANK 1: BANK START — отвечает за первую генерацию яблока и чтение клавиатуры
apple_random:
  ld a, score ;смотрим, не превысила ли длина 200
  ldi b, 256 - 200
  add a, b
  jnc apple_random1 ;если нет, генерируем яблоко первым способом
  ;если да, то вторым способом
  ldi c, 3
  ldi d, apple_random2
  jmp set_bank
apple_random1:
  rnd a ;генерируем случайное число
  ldi c, 7 ;смотрим последние 3 бита (в регистре c будет число от 0 до 7)
  and c, a
  ldi b, 0b10000000 ;сдвигаем положение на случайное число от 0 до 7
  ;это обеспечивает случайную позицию яблока в байте
  loop:
    shr b
    dec c
    jns loop
  rcl b
  ;сдвигаем a 3 раза
  shr a
  shr a
  shr a
  ;прибавляем адрес дисплея и получаем случайный адрес на дисплее для яблока
  ldi c, 0x40
  add a, c
  ;проверка на попадание яблока на змейку
  mov d, a
  shr c ;0x20
  add d, c ;переключаемся на синий дисплей
  ld c, d ;читаем байт синего дисплея
  and c, b ;если попали на змейку, начинаем сначала
  jnz apple_random1
end_apple_random:
  st a, apple_adress ;сохраняем адрес яблока
  st b, apple_pos ;сохраняем позицию в байте яблока
  ;выводим яблоко на дисплей
  ld c, a
  or c, b
  st c, a
add_score:
  ;прибавляем длину
  ld a, score
  inc a
  st a, score
  ;если длина стала 255, переходим к победе
  not a
  jnz add_last_cell
  ldi c, 5
  ldi d, win_start
  jmp set_bank
add_last_cell:
  ld a, last_cell_pos ;читаем позицию последней клетки
  dec a ;уменьшаем количество сдвигов на 2
  dec a
  jns save_last_cell ;если число неотрицательное, сохраняем позицию
  ldi a, 6 ;если отрицательное, обновляем количество сдвигов
  ld b, last_cell_adress ;увеличиваем на 1 адрес последней клетки
  inc b
  st b, last_cell_adress
save_last_cell:
  st a, last_cell_pos
key_read:
  ldi c, 2
  ;читаем клавишу
  ld a, in_out ;key_read + 2
  ld b, lock_key ;если она запретная, читаем заново
  xor b, a
  jz key_read + 2
  ;клавиша "вправо"
  ldi b, KEY_RIGHT ;key_read + 9
  xor b, a
  jz right
  ;клавиша "влево"
  ldi b, KEY_LEFT
  xor b, a
  jz left
  ;клавиша "вверх"
  ldi b, KEY_UP
  xor b, a
  jz up
  ;клавиша "вниз"
  ldi b, KEY_DOWN
  xor b, a
  jz down
  ;если введена не одна из доступных клавиш, проверяем последнюю
  ld a, last_key
  jmp key_read + 9
;регистр c уже содержит 2 (2-й банк)
right:
  ldi d, right_start ;вправо
  jmp set_bank
left:
  ldi d, left_start ;влево
  jmp set_bank
up:
  ldi d, up_start ;вверх
  jmp set_bank
down:
  ldi d, down_start ;вниз
  jmp set_bank
void2 db 0, 0, 0, 0, 0, 0
;BANK 2: BANK MOVE — отвечает за движение змейки и проверку на конец игры
right_start:
  st a, last_key ;сохраняем введённое направление
  ldi a, KEY_LEFT ;задаём новое запретное направление
  st a, lock_key
  ld a, head_pos ;читаем позицию головы в байте
  ld b, head_adress ;читаем адрес головы на дисплее
  shr a ;сдвигаем позицию вправо
  jnc next_jmp ;если не вышли за рамки, переходим к сохранению
  mov c, b ;если адрес нечётный, значит мы упёрлись в правый край
  ;и завершаем игру
  shr c
  jc game_over
  ;задаём новую позицию и увеличиваем адрес
  ldi a, 0b10000000
  inc b
  jmp next_jmp
;то же самое, что и для правой, но наоборот
left_start:
  st a, last_key
  ldi a, KEY_RIGHT
  st a, lock_key
  ld a, head_pos
  ld b, head_adress
  shl a
  jnc next_jmp
  mov c, b
  shr c
  jnc game_over
  ldi a, 0b00000001
  dec b
  jmp next_jmp
up_start:
  st a, last_key
  ldi a, KEY_DOWN
  st a, lock_key
  ld a, head_pos ;читаем позицию головы
  ld b, head_adress ;читаем адрес головы
  ldi c, 0x60 ;проверяем столкновение с верхней стеной
  xor c, b
  shr c
  jz game_over
  dec b ;сдвигаем адрес вверх
  dec b
  jmp next_jmp
;то же самое, что и для верхней, но наоборот
down_start:
  st a, last_key
  ldi a, KEY_UP
  st a, lock_key
  ld a, head_pos
  ld b, head_adress
  ldi c, 0x7e
  xor c, b
  shr c
  jz game_over
  inc b
  inc b
next_jmp:
  ;проверяем столкновение с хвостом
  ld c, b
  and c, a
  jnz game_over
  st b, save ;сохраняем регистр b
  ld c, head_pos ;читаем старую позицию
  ld d, head_adress ;читаем старый адрес
  ldi b, 0x20 ;переходим на красный дисплей
  sub d, b
  ld b, d ;убираем голову
  xor b, c
  st b, d
  ld b, save ;читаем b обратно
  st a, head_pos ;сохраняем новые координаты головы змейки
  st b, head_adress
  ld c, b ;выводим синюю часть головы на дисплей
  or c, a
  st c, b
  ldi c, 3
  ldi d, next_jmp2
  jmp set_bank
;переход к концу игры
game_over:
  ldi c, 5
  ldi d, game_over_start
  jmp set_bank
void3 db 0, 0, 0, 0, 0, 0, 0, 0, 0
;BANK 3: BANK TAIL, BANK COLLISION, BANK RANDOM 2 —
;отвечает за обработку коллизий с яблоком, перемещение хвоста
;и вторую генерацию яблока
;BANK COLLISION
next_jmp2:
  ldi c, 0x20 ;выводим красную часть головы на дисплей
  sub b, c
  ld c, b
  or c, a
  st c, b
check_collision_apple:
  ld b, apple_pos ;проверяем столкновение с яблоком
  xor a, b
  jnz jmp_bank_4
  ldi c, 0x20
  ld a, head_adress
  ld b, apple_adress
  add b, c
  xor a, b
  jnz jmp_bank_4
eating_apple:
  ;если есть столкновение, меняем адрес перехода
  ;после сохранения направления головы и переходим к ней
  ldi a, other_bank
  st a, next
  ldi c, 4
  ldi d, save_head_cell
  jmp set_bank
jmp_bank_4:
  ;если столкновения нет, восстанавливаем адрес перехода
  ;и идём удалять хвост
  ldi a, loop3_start
  st a, next
  ldi c, 4
  ldi d, delete_tail
  jmp set_bank
;BANK TAIL
new_tail2:
  ldi d, save_tail ;сохраняем адрес перехода, чтобы использовать меньше байт
  ld b, tail_adress ;заранее читаем адрес хвоста
  ld a, tail_pos ;заранее читаем позицию хвоста в байте
  ld c, save ;читаем сохранённое направление хвоста
  dec c
  js tail_down ;вниз
  dec c
  js tail_left ;влево
  dec c
  js tail_up ;вверх
  ;вправо
tail_right:
  shr a ;сдвигаем позицию вправо
  jnc d ;если перехода между байтами нет, переходим к сохранению
  ldi a, 0b10000000 ;если переход есть, перемещаем позицию в левый край
  inc b ;сдвигаем адрес вправо
  jmp d ;переходим к сохранению
tail_up:
  dec b ;сдвигаем позицию вверх
  dec b
  jmp d ;переходим к сохранению
tail_left:
  ;то же самое, что и для правой, но наоборот
  shl a
  jnc d
  ldi a, 0b00000001
  dec b
  jmp d
tail_down:
  ;то же самое, что и для верхней, но наоборот
  inc b
  inc b
save_tail:
  st a, tail_pos ;сохраняем новые координаты хвоста
  st b, tail_adress
end:
  clr c ;переходим на чтение клавиши
  ldi d, key_read
  jmp set_bank
;BANK RANDOM 2
apple_random2:
  ld c, score ;читаем счёт
  inc c ;прибавляем 1 (змейка уже длиннее на 1, чем указано в счёте)
  neg c ;c = 256 - c
  rnd d ;генерируем случайное число
  ldi b, mod_d_c ;сохраняем адрес цикла для его ускорения
mod_d_c:
  sub d, c ;вычитаем, пока число не станет ниже нуля
  jnc b
add d, c ;складываем обратно и получаем остаток от деления d на c
ldi a, 0x5f ;адрес яблока (для удобства на синем дисплее)
random_loop1:
  inc a ;прибавляем 1
  ldi b, 0b10000000 ;перемещаем позицию яблока в начало
  random_loop2:
    ld c, a ;читаем байт по адресу на дисплее
    and c, b ;если попали на хвост змейки, переходим в конец
    jnz end_random2
    dec d ;если нет, убавляем счётчик
    js end_random ;если счётчик ниже нуля, выходим из цикла
  end_random2:
    shr b ;сдвигаем позицию вправо
    jnc random_loop2 ;если не сдвинули за край байта, начинаем сначала
  jmp random_loop1 ;если сдвинули, смещаем адрес
end_random:
  ldi c, 0x20 ;переходим на красный дисплей
  sub a, c
  clr c ;переходим на сохранение яблока на дисплей
  ldi d, end_apple_random
  jmp set_bank
void4 db 0, 0, 0, 0, 0, 0, 0, 0, 0
;BANK 4: BANK SNAKE — здесь хранятся направления хвоста змейки и их обработка
delete_tail:
  ;удаляем хвост
  ld a, tail_pos
  ld b, tail_adress
  ld c, b
  xor c, a
  st c, b
new_tail:
  ;сохраняем следующее направление хвоста
  ld a, snake
  clr b
  shl a
  rcl b
  shl a
  rcl b
  st b, save
save_head_cell:
  ;сохраняем направление головы
  ld a, last_cell_pos
  ld b, last_cell_adress
  ld c, last_key ;направление головы можно узнать по
  ;двум последним битам нажатой клавиши
  ldi d, 3
  and c, d
loop2:
  shl c ;сдвигаем направление на нужную позицию
  dec a
  jns loop2
rcr c
;сохраняем направление
ld d, b
or d, c
st d, b
ld a, next ;читаем адрес перехода
jmp a ;переходим по адресу
loop3_start:
  ldi c, snake ;вычисляем количество итераций цикла
  sub b, c
loop3:
  ld d, c ;читаем текущие направления
  inc c
  ld a, c ;читаем следующие направления
  ;сдвигаем
  shl a
  rcl d
  shl a
  rcl d
  ;сохраняем
  dec c
  st d, c
  inc c
  ;если направления ещё остались, повторяем итерацию
  dec b
  jns loop3
;переходим к определению нового хвоста
ldi c, 3
ldi d, new_tail2
jmp set_bank
;все направления для максимально длинной змейки
snake db 0b11110000,
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
0b00000000, 0b00000000,
0b00000000, 0b00000000,
0b00000000, 0b00000000,
0b00000000
fill db 0b00000000 ;если змейка достигнет почти максимальной длины,
;пустые направления берутся отсюда
void5 db 0, 0, 0, 0, 0
;BANK 5: BANK END — содержит вывод о победе и поражении игрока
;развёрнутый текст конца игры
game_over_text db "!niaga yrT \n!gniyalp  \nrof sknahT \n!revo emaG "
game_over_start:
  ldi b, game_over_start - 1 ;адрес чтения
  ldi c, terminal ;адрес вывода символа
  ldi d, game_over_loop_text ;адрес цикла
game_over_loop_text:
  ld a, b ;читаем символ
  st a, c ;выводим в терминал
  dec b ;если символы ещё остались, продолжаем
  js d
hlt ;конец
win_start:
  ;аналогично с проигрышем выводим победный текст
  ldi b, win_text
  ldi c, terminal
  ldi d, win_loop_text
win_loop_text:
  ld a, b
  st a, c
  inc b
  jnz d
inc c ;адрес 0x3d для произвольной графики
ldi a, 0b00111000 ;левая половина онигири
ldi b, 0b01000100
ldi d, 0b01110010
;сохраняем левую половину онигири
st a, c
st b, c
st d, c
;правая половина онигири зеркально симметрична левой
st d, c
st b, c
st a, c
hlt ;конец
void6 db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0
;победный текст
win_text db "  You won!\n\nTake an\nonigiri — "