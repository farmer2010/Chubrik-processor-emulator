ADD_D_C equ 0x6b ;код команды add d, c (сместить курсор вниз)
SUB_D_C equ 0x7b ;код команды sub d, c (сместить курсор вверх)
INC_D equ 0x6F ;код команды inc d (сместить курсор вправо)
DEC_D equ 0x7F ;код команды dec d (сместить курсор влево)
emoji equ field + 11 ;адрес смайлика на поле
space equ field + 23 ;адрес пробела на поле
enter equ field + 35 ;адрес символа enter на поле
mine equ 0xa4 ;символ, обозначающий мину
cursor equ 0x40 ;адрес хранения курсора
row equ 0x41 ;адрес хранения колонки
column equ 0x42 ;адрес хранения строки
save equ 0x43 ;адрес сохранения важных значений
adress_end equ 0x44 ;адрес хранения перехода после вывода поля
field equ 128 - 47 ;адрес поля
ldi a, 0b00000101 ;подключаем цифровой индикатор и терминал
st a, 0x3e
ldi a, 2 ;заменяем заставку на поле
ldi b, field_loop
ldi d, field
field_loop:
  st a, d
  inc d
  jns b
inc a
st a, enter
inc a
st a, emoji
ldi a, " "
st a, space
jmp ask_start ;переходим к старту
set_bank: ;банкинг с регистрами c и d
  st c, bank
  jmp d
set_bank2: ;банкинг с регистрами a и b
  st a, bank
  jmp b
ask_row_text db "\f\rrow (a-k): " ;текст опроса колонки
ask_row_size equ $ - ask_row_text
ask_column_text db "column\n(1-4): " ;текст опроса строки
ask_column_size equ $ - ask_column_text
bcd db 0, 0 ;цифровой индикатор (показывает кол-во оставшихся пустых клеток)
terminal db 0 ;вывод символов
terminal_art db 0 ;вывод графики
in_out db 0b00110000 ;ввод-вывод (подключаем цветной дисплей для заставки)
bank db 0 ;банк
display_r db ;заставка
0b00000000, 0b00001100,
0b00000000, 0b00000010,
0b00000000, 0b00000100,
0b00000000, 0b00000010,
0b00000001, 0b00001100,
0b00001001, 0b00100000,
0b00000011, 0b10000000,
0b00000101, 0b11000000,
0b00011111, 0b11110000,
0b00000111, 0b11000000,
0b00000011, 0b10000100,
0b11001001, 0b00100111,
0b00100001, 0b00000110,
0b01000000, 0b00000000,
0b10000000, 0b00000000,
0b11100000, 0b00000000
display_b db
0b00100000, 0b00000000,
0b01100000, 0b00000000,
0b00100000, 0b00000000,
0b01110000, 0b00000000,
0b00000001, 0b00000000,
0b00001001, 0b00100000,
0b01000011, 0b10000000,
0b11000101, 0b11000000,
0b01011111, 0b11110000,
0b11100111, 0b11000000,
0b00000011, 0b10000000,
0b00001001, 0b00100000,
0b00000001, 0b00000000,
0b00000000, 0b00000100,
0b00000000, 0b00000100,
0b00000000, 0b00001110
ask_start:
  ldi d, terminal ;адрес вывода
ask:
  ldi b, ask_row_size ;размер текста
  ldi c, ask_row_text ;адрес текста
ask_row_loop:
  ld a, c ;читаем символ
  st a, d ;выводим
  inc c ;следующий символ
  dec b ;если символы не закончились, продолжаем
  jnz ask_row_loop
ask_row:
  ld a, in_out ;читаем ввод пользователя
  mov c, a ;копируем символ
  ldi b, "a" ;проверяем, находится ли символ в диапазоне от a до k (включительно)
  sub a, b
  jc ask_row
  ldi b, 10
  sub b, a
  jc ask_row
  st c, d ;если символ в диапазоне, выводим его
  st a, row ;и сохраняем колонку
ldi b, ask_column_size ;то же самое, но для строки
ldi c, ask_column_text
ask_column_loop:
  ld a, c
  st a, d
  inc c
  dec b
  jnz ask_column_loop
ask_column:
  ld a, in_out
  mov c, a
  ldi b, "1"
  sub a, b
  jc ask_column
  ldi b, 3
  sub b, a
  jc ask_column
  st c, d
  st a, column
;вычисляем курсор
ld b, row
mov c, a ;умножение на 12 (ширина терминала - 12 символов)
add a, c
add a, c
shl a
shl a
add a, b
ldi b, field
add a, b
st a, cursor ;сохраняем курсор
ask_jmp:
  jmp random ;заменяемый адрес перехода
random:
  ldi b, 1 ;чтобы мина изначально не попала на ввод пользователя, временно сохраняем туда мину
  st b, a
  ldi d, 10 ;генерируем 10 мин
  random_column: ;генерируем строку
    rnd a
    ldi b, 3
    and a, b
  random_row: ;генерируем колонку
    rnd b
    ldi c, 11
    mod_b_c:
      sub b, c
      jnc mod_b_c
    add b, c
  mov c, a ;вычисляем положение на поле
  add a, c
  add a, c
  shl a
  shl a
  add a, b
  ldi b, field
  add a, b
  ld b, a ;если попали на мину, генерируем заново
  dec b
  jz random_column
  st b, a ;если нет, сохраняем мину на поле
  dec d ;если мины ещё остались, продолжаем
  jnz random_column
ld a, cursor ;изначально ввод пользователя должен быть на свободную клетку
ldi b, 2
st b, a
ldi b, 34 ;выводим количество оставшихся пустых клеток на цифровой индикатор
st b, bcd
ldi b, check_mine_jmp ;меняем адрес перехода
st b, ask_jmp + 1
ldi b, wait ;сохраняем адрес перехода после вывода поля
st b, adress_end
check_mine_jmp:
  ldi c, 2 ;переход на проверку столкновения с миной
  ldi d, check_mine
  jmp set_bank
void2 db 0, 0, 0
check_mine:
  ld b, a ;читаем клетку, которую указал пользователь
  dec b ;если попали на мину, переходим к концу игры
  jnz check_repeat
  ldi c, 4
  ldi d, game_over
  jmp set_bank
check_repeat:
  dec b ;проверяем, не указал ли пользователь уже открытую клетку
  jz check_side
  ldi c, 5 ;если да, выводим поле без изменений
  ldi d, draw_field
  jmp set_bank
check_side:
  mov d, a ;копируем курсор в d
  ldi c, 12 ;число, которое позволяет сдвигать курсор вверх и вниз
  ld a, column ;читаем строку
  test a ;если строка верхняя, переходим на подсчёт верхней горизонтальной стороны
  jz horizontal_side_up_jmp
  ldi b, 3
  xor a, b ;если строка нижняя, переходим на подсчёт нижней горизонтальной стороны
  jz horizontal_side_down_jmp
  ld a, row ;читаем колонку
  test a ;если колонка левая, переходим на подсчёт левой вертикальной стороны
  jz vertical_side_left_jmp
  ldi b, 10
  xor a, b ;если колонка правая, переходим на подсчёт правой вертикальной стороны
  jz vertical_side_right_jmp
;пользователь указал центральные координаты, подсчитываем все клетки вокруг
next0:
  clr a ;счётчик мин
  sub d, c ;смещаем курсор вверх (верхняя клетка)
  ld b, d ;читаем
  dec b ;если попали на мину, увеличиваем счётчик
  jnz next1
  inc a
;повторяем то же самое для других окружающих клеток
next1:
  inc d ;смещаем курсор вправо (верхняя правая клетка)
  ld b, d
  dec b
  jnz next2
  inc a
next2:
  add d, c ;смещаем курсор вниз (правая клетка)
  ld b, d
  dec b
  jnz next3
  inc a
next3:
  add d, c ;смещаем курсор вниз (нижняя правая клетка)
  ld b, d
  dec b
  jnz next4
  inc a
next4:
  dec d ;смещаем курсор влево (нижняя клетка)
  ld b, d
  dec b
  jnz next5
  inc a
next5:
  dec d ;смещаем курсор влево (нижняя левая клетка)
  ld b, d
  dec b
  jnz next6
  inc a
next6:
  sub d, c ;смещаем курсор вверх (левая клетка)
  ld b, d
  dec b
  jnz next7
  inc a
next7:
  sub d, c ;смещаем курсор вверх (верхняя левая клетка)
  ld b, d
  dec b
  jnz end_counter
  inc a
end_counter:
  ldi c, 5 ;переход на вывод поля
  ldi d, show_counter
  jmp set_bank
horizontal_side_up_jmp:
  ldi a, 3 ;переход на подсчёт для верхней клетки
  ldi b, horizontal_side_up
  jmp set_bank2
horizontal_side_down_jmp:
  ldi a, 3 ;переход на подсчёт для нижней клетки
  ldi b, horizontal_side_down
  jmp set_bank2
vertical_side_left_jmp:
  ldi a, 4 ;переход на подсчёт для левой клетки
  ldi b, vertical_side_left
  jmp set_bank2
vertical_side_right_jmp:
  ldi a, 4 ;переход на подсчёт для правой клетки
  ldi b, vertical_side_right
  jmp set_bank2
void3 db 0, 0, 0, 0, 0, 0, 0
;подсчёт для верхней клетки
horizontal_side_up:
  ld a, row ;читаем колонку
  test a ;если колонка левая, переходим на подсчёт для верхней левой клетки
  jz corner_up_left
  ldi b, 10
  xor a, b ;если колонка правая, переходим на подсчёт для верхней правой клетки
  jz corner_up_right
  ldi a, ADD_D_C ;заменяем операцию на движение курсора вниз
  st a, next11
  ldi a, SUB_D_C ;заменяем операцию на движение курсора вверх
  st a, next14
  jmp next10 ;переход к подсчёту
horizontal_side_down:
  ld a, row ;читаем колонку
  test a ;если колонка левая, переходим на подсчёт для нижней левой клетки
  jz corner_down_left_jmp
  ldi b, 10
  xor a, b ;если колонка правая, переходим на подсчёт для нижней правой клетки
  jz corner_down_right_jmp
  ldi a, SUB_D_C ;заменяем операцию на движение курсора вверх
  st a, next11
  ldi a, ADD_D_C ;заменяем операцию на движение курсора вниз
  st a, next14
next10:
  clr a ;счётчик мин
  dec d ;сдвигаем курсор влево (левая клетка)
  ld b, d ;читаем
  dec b ;если попали на мину, увеличиваем счётчик
  jnz next11
  inc a
next11:
  add d, c ;для верхней клетки смещаем курсор вниз (нижняя левая клетка)
  ;sub d, c для нижней клетки смещаем курсор вверх (верхняя левая клетка)
  ld b, d
  dec b
  jnz next12
  inc a
next12:
  inc d ;смещаем курсор вправо
  ;(для верхней клетки нижняя клетка)
  ;(для нижней клетки верхняя клетка)
  ld b, d
  dec b
  jnz next13
  inc a
next13:
  inc d ;смещаем курсор вправо
  ;(для верхней клетки - нижняя правая клетка)
  ;(для нижней клетки - верхняя правая клетка)
  ld b, d
  dec b
  jnz next14
  inc a
next14:
  sub d, c ;для верхней клетки смещаем курсор вверх (правая клетка)
  ;add d, c для нижней клетки смещаем курсор вниз (правая клетка)
  ld b, d
  dec b
  jnz end_counter2
  inc a
  jmp end_counter2 ;переход к выводу поля
;подсчёт для верхней левой клетки
corner_up_left:
  ldi a, INC_D ;заменяем операцию на движение курсора вправо
  st a, next31
  jmp next30 ;переход к подсчёту
;подсчёт для верхней правой клетки
corner_up_right:
  ldi a, DEC_D ;заменяем операцию на движение курсора влево
  st a, next31
next30:
  clr a ;счётчик мин
  add d, c ;смещаем курсор вниз (нижняя клетка)
  ld b, d ;читаем
  dec b ;если попали на мину, увеличиваем счётчик
  jnz next31
  inc a
next31:
  inc d ;для верхней левой клетки смещаем курсор вправо (нижняя правая клетка)
  ;dec d для верхней правой клетки смещаем курсор влево (нижняя левая клетка)
  ld b, d
  dec b
  jnz next32
  inc a
next32:
  sub d, c ;смещаем курсор вверх
  ;(для верхней левой клетки - правая клетка)
  ;(для верхней правой клетки - левая клетка)
  ld b, d
  dec b
  jnz end_counter2
  inc a
  jmp end_counter2
end_counter2: ;переход к отрисовке поля
  ldi c, 5
  ldi d, show_counter
  jmp set_bank
corner_down_left_jmp: ;переход на подсчёт для нижней левой клетки
  ldi a, 4
  ldi b, corner_down_left
  jmp set_bank2
corner_down_right_jmp: ;переход на подсчёт для нижней правой клетки
  ldi a, 4
  ldi b, corner_down_right
  jmp set_bank2
void4 db 0, 0, 0, 0, 0, 0, 0, 0
;подсчёт для левой клетки
vertical_side_left:
  ldi a, INC_D ;заменяем операцию на движение курсора вправо
  st a, next21
  ldi a, DEC_D ;заменяем операцию на движение курсора влево
  st a, next24
  jmp next20 ;переход к подсчёту
;подсчёт для правой клетки
vertical_side_right:
  ldi a, DEC_D ;заменяем операцию на движение курсора влево
  st a, next21
  ldi a, INC_D ;заменяем операцию на движение курсора вправо
  st a, next24
next20:
  clr a ;счётчик мин
  sub d, c ;смещаем курсор вверх (верхняя клетка)
  ld b, d ;читаем
  dec b ;если попали на мину, увеличиваем счётчик
  jnz next21
  inc a
next21:
  inc d ;для левой клетки смещаем курсор вправо (верхняя правая клетка)
  ;dec d для правой клетки смещаем курсор влево (верхняя левая клетка)
  ld b, d
  dec b
  jnz next22
  inc a
next22:
  add d, c ;смещаем курсор вниз
  ;(для левой клетки - правая клетка)
  ;(для правой клетки - левая клетка)
  ld b, d
  dec b
  jnz next23
  inc a
next23:
  add d, c ;смещаем курсор вниз
  ;(для левой клетки - нижняя правая клетка)
  ;(для правой клетки - нижняя левая клетка)
  ld b, d
  dec b
  jnz next24
  inc a
next24:
  dec d ;для левой клетки смещаем курсор влево (нижняя клетка)
  ;inc d для правой клетки смещаем курсор вправо (нижняя клетка)
  ld b, d
  dec b
  jnz end_counter3
  inc a
  jmp end_counter3 ;переход к отрисовке поля
;подсчёт для нижней левой клетки
corner_down_left:
  ldi a, INC_D ;заменяем операцию на смещение курсора вправо
  st a, next41
  jmp next40 ;переход к подсчёту
;подсчёт для нижней правой клетки
corner_down_right:
  ldi a, DEC_D ;заменяем операцию на смещение курсора влево
  st a, next41
next40:
  clr a ;счётчик мин
  sub d, c ;смещаем курсор вверх (верхняя клетка)
  ld b, d ;читаем
  dec b ;если попали на мину, увеличиваем счётчик
  jnz next41
  inc a
next41:
  inc d ;для нижней левой клетки смещаем курсор вправо (верхняя правая клетка)
  ;dec d для нижней правой клетки смещаем курсор влево (верхняя левая клетка)
  ld b, d
  dec b
  jnz next42
  inc a
next42:
  add d, c ;смещаем курсор вниз
  ;(для нижней левой клетки - правая клетка)
  ;(для нижней правой клетки - левая клетка)
  ld b, d
  dec b
  jnz end_counter3
  inc a
end_counter3: ;переход к отрисовке поля
  ldi c, 5
  ldi d, show_counter
  jmp set_bank
game_over: ;поражение
  ldi a, end ;меняем адрес перехода после отрисовки поля
  st a, adress_end
  ldi a, 6 ;меняем смайлик игры на смайлик поражения
  st a, emoji
  ldi a, " " ;убираем enter
  st a, enter
  ldi b, mine_loop ;адрес цикла
  ldi c, field ;адрес поля
  ldi d, mine ;символ мины
  mine_loop: ;меняем все мины на их символы
    ld a, c
    dec a
    jnz end_mine_loop
    st d, c
    end_mine_loop:
      inc c
      jns b
  ;переход к отрисовке поля
  ldi c, 5
  ldi d, draw_field
  jmp set_bank
void db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
show_counter:
  test a ;если на счётчике ноль, то вместо нуля показываем пустую клетку
  jz zero
  ldi b, 0x30 ;превращаем счётчик в символ
  add a, b
  ld b, cursor ;сохраняем
  st a, b
  jmp check_win ;переходим к проверке на победу
zero:
  ldi a, " " ;вместо нуля используем пробел (пустую клетку)
  ld b, cursor
  st a, b
check_win:
  ld a, bcd ;читаем количество оставшихся пустых клеток
  dec a ;уменьшаем
  st a, bcd ;сохраняем
  jnz draw_field ;если пустых клеток не осталось, выполняем действия для победы
  ldi a, end ;меняем адрес перехода после отрисовки поля
  st a, adress_end
  ldi a, 5 ;меняем смайлик игры на смайлик победы
  st a, emoji
  ldi a, " " ;убираем enter
  st a, enter
draw_field:
  ldi c, field ;адрес поля
  ldi d, terminal ;адрес вывода символов
  ldi a, "\n" ;рисуем поле с новой строки
  st a, d
draw_field_loop: ;цикл отрисовки поля
  ld a, c ;читаем фрагмент поля
  dec a ;вычитаем 1 для проверки на мину
  jnz check_draw ;если не попали на мину, переходим к проверке на графику
  inc a ;обратно прибавляем 1
  jmp draw ;переходим к отрисовке собственного символа
  check_draw:
    ldi b, 7 ;если фрагмент < 7, значит это собственный символ
    sub a, b
    add a, b
    jc draw
    ;если фрагмент > 7, значит это символ в терминале
    inc a ;обратно прибавляем 1
    st a, d ;выводим символ в терминал
    jmp check_end ;переход к проверке на конец цикла
  draw:
    st c, save ;сохраняем адрес фрагмента
    ldi c, cell ;самый первый символ
    dec a ;убавляем ещё 1
    mov b, a ;и умножаем на 6
    add a, b
    add a, b
    shl a
    add c, a ;получаем адрес символа
    inc d ;адрес 0x3d для произвольной графики
    ldi b, 6 ;размер символа
  draw_loop:
    ld a, c ;читаем часть символа
    st a, d ;сохраняем
    inc c
    dec b ;если символ ещё не выведен, продолжаем сохранять
    jnz draw_loop
  dec d ;обратно возвращаемся на 0x3c для вывода символов
  ld c, save ;восстанавливаем адрес фрагмента
  check_end:
    inc c ;если фрагменты ещё остались, повторяем заново
    jns draw_field_loop
ld a, adress_end ;читаем адрес перехода
jmp a ;переход по адресу
wait:
  ld a, in_out ;ждём реакции пользователя для опроса
  test a
  jz wait
  clr a ;переходим к опросу (регистр d уже содержит адрес вывода текста)
  ldi b, ask
  jmp set_bank2
end:
  hlt ;конец
cell db ;символ клетки
0b11111110,
0b10000010,
0b10000010,
0b10000010,
0b11111110,
0b00000000
enter_draw db ;символ enter
0b00000000,
0b00100000,
0b01110000,
0b00100000,
0b00111110,
0b00000000
play db ;смайлик игры
0b00000000,
0b00100100,
0b01000000,
0b01000000,
0b00100100,
0b00000000
win db ;смайлик победы
0b00000110,
0b00100110,
0b01000010,
0b01000010,
0b00100110,
0b00000110
lose db ;смайлик поражения
0b00000000,
0b01000100,
0b00100000,
0b00100000,
0b01000100,
0b00000000
