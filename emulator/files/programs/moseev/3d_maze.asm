KEY_RIGHT equ 0x13 ;код клавиши вправо
KEY_LEFT equ 0x11 ;код клавиши влево
KEY_UP equ 0x12 ;код клавиши вверх
ray_start: ;начало вычислений для лучей
  ldi a, 16 ;восстанавливаем количество лучей, которые не врезались в стену
  st a, walls
  dec a ;считаем с конца (15 луча) для оптимизации
ray_loop:
  st a, i ;сохраняем номер текущего луча
  ldi b, 4 ;переключаемся на 4 банк
  st b, bank
  ldi b, rays ;читаем координату текущего луча
  add b, a
  ld b, b
  st b, f_coord ;сохраняем координату в аргумент для функции
  clr c ;первый банк
start_bank: ;для сокращения кода на метки в начале банка, переход здесь
  ldi d, 0x80
set_bank: ;банкинг
  st c, bank
  jmp d
end_ray_loop: ;конец обработки луча
  ld a, i ;читаем номер луча
  dec a ;следующий луч
  jns ray_loop ;если лучи ещё остались, продолжаем обрабатывать
ld a, walls ;если все лучи обработаны, читаем количество лучей, которые не врезались в стену
test a ;если остались "подвижные" лучи, обрабатываем лучи заново
jnz ray_start
ldi c, 6 ;переходим к отрисовке стен
ldi d, clear_start
jmp set_bank
wall_jmp: ;переход на случай, если луч или игрок врезались в стену не в 4 банке
  ldi c, 4
  ldi d, wall
  jmp set_bank
void1 db 0, 0, 0, 0, 0
dir db 0 ;направление игрока (0 - 23)
f_coord db 0 ;1 аргумент функции - координата
f_dir db 0, 0 ;2 и 3 аргумент - направление (направление от 0 до 359, 359 > 256, поэтому используем 2 байта)
output_bank1 db 0 ;4 аргумент - банк перехода после функции
output_adress1 db 0 ;5 аргумент - адрес перехода после функции
output_bank2 db 0 ;банк перехода после чтения синуса/косинуса
output_adress2 db 0 ;адрес перехода после чтения синуса/косинуса
speed_ray_x db 0 ;скорость (-1 - 1) по x
speed_ray_y db 0 ;скорость (-1 - 1) по y
walls db 0 ;количество лучей, которые не врезались в стену
i db 0 ;текущий луч
in_out db 0b00010000 ;ввод-вывод (подключаем монохромный дисплей)
bank db 0 ;банк
display db ;дисплей (заставка + стены)
0b00000000, 0b00000000,
0b00011100, 0b01110000,
0b00000010, 0b01001000,
0b00000010, 0b01001000,
0b00011100, 0b01001000,
0b00000010, 0b01001000,
0b00000010, 0b01001000,
0b00011100, 0b01110000,
0b00000000, 0b00000000,
0b00000000, 0b00000000,
0b10001000, 0b00000000,
0b11011011, 0b00110010,
0b10101001, 0b10010101,
0b10001010, 0b10100110,
0b10001001, 0b10110011,
0b00000000, 0b00000000
map db ;лабиринт
0b00000000, 0b00100011,
0b00000000, 0b00101010,
0b00111010, 0b00101010,
0b00101010, 0b00101010,
0b00101111, 0b11101010,
0b00100000, 0b00101000,
0b00001110, 0b00101011,
0b00001010, 0b00101000,
0b00101010, 0b00101110,
0b00101010, 0b00101000,
0b00100010, 0b00101011,
0b00111110, 0b00101000,
0b00000110, 0b11101110,
0b00000010, 0b00101000,
0b00000011, 0b10101011,
0b00000010, 0b00001000

;BANK 1: BANK DIR - содержит чтение и обработку направлений лучей,
;BANK CHECK PLAYER WALL - содержит проверку на столкновение игрока со стеной
;BANK DIR
;получаем направление луча
;регистр a уже содержит номер текущего луча
get_dir:
  mov c, a ;копируем
  ldi a, dirs + 1 ;первый младший байт
  ldi b, dirs ;первый старший байт
  shl c ;умножаем на 2
  add a, c ;получаем адреса каждого байта у направления
  add b, c
  ld a, a ;читаем байты
  ld b, b
  ldi c, 15 ;добавляем 15, столько раз, сколько сейчас направление у игрока
  ld d, dir ;читаем направление
mul_loop:
  st d, j ;сохраняем в счётчик для 1 банка
  clr d ;добавляем 15
  add a, c
  adc b, d
  ld d, j ;читаем счётчик
  dec d ;продолжаем, пока он не опустится до 0
  jns mul_loop
clr d ;вычитаем 15 (потому что в цикле прибавлений было на 1 раз больше)
sub a, c
sbb b, d
check: ;проверяем, не превысило ли направление 359
  ldi c, 359 - 256 ;если направление превышает 359, вычитаем из него 360
  inc d
  sub c, a
  sbb d, b
  jnc end_get_dir ;если направление меньше 360, переходим к задаванию параметров функции
  ldi c, 360 - 256 ;вычитаем 360
  ldi d, 1
  sub a, c
  sbb b, d
  jmp check ;проверяем снова
end_get_dir:
  clr d ;сохраняем 0 в банк перехода после функции
  st d, output_bank1
move_coord:
  ;регистры a и b уже содержат направление в 2-байтовом формате
  st a, f_dir + 1 ;сохраняем
  st b, f_dir
  clr c ;обнуляем скорость
  st c, speed_ray_x
  st c, speed_ray_y
  ldi c, 2 ;переходим к обработке направления для синуса
  jmp start_bank
dirs db 1, 69, ;направления лучей
1, 73,
1, 78,
1, 83,
1, 87,
1, 92,
1, 97,
1, 101,
0, 2,
0, 7,
0, 11,
0, 16,
0, 21,
0, 25,
0, 30,
0, 35
j db 0 ;счётчик 1 банка
;BANK CHECK PLAYER WALL
check_player_wall: ;проверка, не врезался ли игрок в стену
  st a, save_coord_player ;сохраняем координату
  ldi c, 7 ;преобразуем в позицию и адрес на карте
  and c, a
  ldi b, 0b10000000
  check_player_loop:
    shr b
    dec c
    jns check_player_loop
  rcl b
  shr a
  shr a
  shr a
  ldi c, map
  add a, c
  ld c, a ;читаем байт с карты
  and c, b ;если врезались в стену, переходим к обработке столкновения
  jnz wall_jmp
  ld a, save_coord_player ;иначе читаем координату
  ldi c, 4 ;переходим к дальнейшей обработке
  ldi d, end_ray_check
  jmp set_bank

save_coord_player db 0 ;сохранение координаты игрока
void2 db 0, 0, 0, 0, 0, 0

;BANK 2: BANK CHECK - содержит обработку преобразование направления
;BANK MOVE 2 - содержит 2 фрагмент движения
;BANK CHECK
;превращаем синус от 0 до 359 в синус от 0 до 180
check_sin:
  ldi c, 180 ;если синус уже ≤ 180, преобразовывать его не нужно
  clr d
  sub c, a
  sbb d, b
  jnc get_pos_sin
  ldi c, 270 - 256 ;если синус ≤ 270 и > 180, преобразовываем его 1 способом
  ldi d, 1
  sub c, a
  sbb d, b
  jnc sin270
sin360: ;синус < 360
  ldi c, 360 - 256 ;из 360 вычитаем направление
  sub c, a
  mov a, c
  jmp get_neg_sin ;двигаемся влево
sin270:
  ldi c, 180 ;вычитаем 180 из направления
  sub a, c
  ;двигаемся влево
get_neg_sin:
  ldi d, neg_sin ;адрес перехода на движение влево
  jmp get_sin_jmp
get_pos_sin: ;двигаемся вправо
  ldi d, pos_sin ;адрес перехода на движение вправо
get_sin_jmp:
  st d, output_adress2 ;сохраняем адрес перехода
  ldi c, 3 ;сохраняем банк перехода
  st c, output_bank2
  ldi c, 5 ;переходим на получение синуса
  ldi d, get_sin
  jmp set_bank
;превращаем косинус от 0 до 359 в косинус от 0 до 90
check_cos:
  ld a, f_dir + 1 ;читаем младший байт направления
  ld b, f_dir ;читаем старший байт направления
  ldi c, 90 ;если косинус уже ≤ 90 - ничего не делаем
  clr d
  sub c, a
  sbb d, b
  jnc get_pos_cos
  ldi c, 180 ;если косинус ≤ 180 и > 90, переходим к его обработке
  clr d
  sub c, a
  sbb d, b
  jnc cos180
  ldi c, 270 - 256 ;если косинус ≤ 270 и > 180, переходим к его обработке
  ldi d, 1
  sub c, a
  sbb d, b
  jnc cos270
  ;если косинус < 360 и > 270, обрабатываем его
cos360:
  ldi c, 360 - 256 ;из 360 вычитаем направление
  sub c, a
  mov a, c
get_pos_cos:
  ldi d, pos_cos ;двигаемся вверх
  jmp get_cos_jmp
cos180:
  ldi c, 180 ;из 180 вычитаем направление
  sub c, a
  mov a, c
  jmp get_neg_cos
cos270:
  ldi c, 180 ;вычитаем 180 из направления
  sub a, c
get_neg_cos:
  ldi d, neg_cos ;двигаемся вниз
get_cos_jmp:
  st d, output_adress2 ;сохраняем адрес перехода
  ldi c, 3 ;сохраняем банк перехода
  st c, output_bank2
  ldi c, 5 ;переходим к чтению косинуса
  jmp start_bank

BANK MOVE 2
;продолжение движения
move_next:
  ldi c, map
  add a, c
  ld c, a ;читаем байт с карты
  and c, b ;если луч в стене, переходим к обработке столкновения
  jnz wall_jmp
  ld a, f_coord ;читаем координату
  mov b, a ;преобразуем в x и y
  ldi c, 0x0f
  and a, c
  not c
  and b, c
ldi c, 4 ;продолжаем в 4 банке
jmp start_bank
void3 db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0


;BANK 3: BANK SIN COS - содержит обработку и сохранение прочитанного синуса или косинуса
;BANK MOVE 1 - содержит 1 фрагмент движения
;BANK SIN COS
neg_sin: ;движение влево
  ldi d, 0 - 1 ;скорость -1
  jmp check_sin_ray
pos_sin: ;движение вправо
  ldi d, 1 ;скорость 1
check_sin_ray:
  ld b, i ;читаем синус у луча
  ldi c, rays_sin
  add c, b
  ld b, c
  add a, b ;добавляем прочитанный синус
  jns check_cos_jmp ;если значение не превысило 1 (старший бит = 1), сохраняем синус
set_speed_x: ;если значение превысило 1, сохраняем скорость
  st d, speed_ray_x
  shl a ;обрезаем старший бит
  shr a
check_cos_jmp:
  st a, c ;сохраняем
  ldi c, 2 ;переходим к проверке косинуса
  ldi d, check_cos
  jmp set_bank

neg_cos: ;движение вниз
  ldi d, 1 ;скорость 1
  jmp check_cos_ray
pos_cos: ;движение вверх
  ldi d, 0 - 1 ;скорость -1
check_cos_ray: ;то же самое, что для check_sin_ray, но для cos
  ld b, i
  ldi c, rays_cos
  add c, b
  ld b, c
  add a, b
  jns move
set_speed_y:
  st d, speed_ray_y
  shl a
  shr a

move:
  st a, c

;BANK MOVE 1
;начало движения луча
  ld a, f_coord ;читаем координату
  ldi c, 7 ;преобразуем в позицию и адрес на карте
  and c, a
  ldi b, 0b10000000
  loop:
    shr b
    dec c
    jns loop
  rcl b
  shr a
  shr a
  shr a
  ldi c, 2 ;переходим ко 2 части движения
  ldi d, move_next
  jmp set_bank

;BANK SIN COS
clear_sin_cos: ;обнуляем синусы лучей
  clr a
  ldi c, 34
  ldi d, rays_sin
clear_sin_cos_loop:
  ldi b, 18 ;синус и косинус игрока имеют индексы 0 и 18 с конца
  xor b, c
  jz end_clear_sin_cos_loop
  test c
  jz end_clear_sin_cos_loop
  st a, d
end_clear_sin_cos_loop:
  inc d
  dec c
  jnz clear_sin_cos_loop
jmp ray_start ;переходим на старт
rays_sin db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0
rays_cos db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0

void4 db 0, 0, 0, 0, 0, 0, 0


;BANK 4: BANK MOVE 3 - содержит 3 фрагмент движения
;BANK RAYS - содержит хранение и обработку лучей
;BANK MOVE 3
ray_y:
  shr b
  shr b
  shr b
  shr b
  ld c, speed_ray_y ;читаем скорость по y
  add b, c ;прибавляем к координате
  test c
  jz ray_x ;если скорость 0, пропускаем проверку
  js ray_up ;переход на проверку для скорости -1
ray_down: ;проверка для скорости 1
  ldi c, 0x0f ;если врезались в нижнюю стену, переходим к столкновению
  and c, b
  jz wall
  jmp ray_x
ray_up: ;проверка для скорости -1
  jnc wall ;если врезались в верхнюю стену, переходим к столкновению
ray_x: ;то же самое, что и для ray_y, но для регистра a (положение x)
  ld c, speed_ray_x
  add a, c
  test c
  jz end_ray
  js ray_left
ray_right:
  ldi c, 0x0f
  and c, a
  jz wall
  jmp end_ray
ray_left:
  jnc wall
end_ray: ;конец обработки луча
  shl b ;преобразуем координаты x и y в один байт
  shl b
  shl b
  shl b
  or a, b
  ld c, output_bank1 ;если выходной банк не 0, обрабатываем столкновение со стеной для игрока в другом банке
  test c
  jz end_ray_check
  clr c
  ldi d, check_player_wall
  jmp set_bank
end_ray_check: ;продолжаем обработку
  ld c, output_bank1 ;читаем банк
  ld d, output_adress1 ;читаем адрес
  test c
  jnz set_bank ;если банк 0, обрабатываем луч, поэтому выполняем код дальше
  ld b, i ;вычисляем адрес координаты луча
  ldi c, rays
  add b, c
  st a, b ;сохраняем новую координату по адресу
  ldi c, 6 ;переходим к прибавлению шага
  jmp start_bank
wall:
  ld a, f_coord ;читаем изначальную координату
  ld c, output_bank1 ;читаем банк
  ld d, output_adress1 ;читаем адрес
  test c
  jnz set_bank ;если банк 0, обрабатываем луч, поэтому выполняем код дальше
  ld a, walls ;читаем количество лучей, которые не врезались в стену
  dec a ;уменьшаем
  st a, walls ;сохраняем
  jmp end_ray_loop ;переходим к концу обработки луча

;BANK RAYS
clear_rays: ;меняем все координаты лучей на координату игрока
  ldi c, 16
  ldi d, rays
clear_rays_loop:
  st a, d
  inc d
  dec c
  jnz clear_rays_loop
ldi c, 3
ldi d, clear_sin_cos ;переходим к обнулению синусов и косинусов
jmp set_bank
get_ray: ;читаем координату луча и переходим к проверке на столкновение с финишем
  ldi c, rays
  add c, a
  ld a, c
  ldi c, 6
  ldi d, check_win
  jmp set_bank
rays db 0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4,
0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4, 0xe4
void5 db 0


;BANK 5: BANK GET - содержит чтение синуса или косинуса и небольшую обработку направления
get_cos: ;функция получения косинуса направления
  ldi b, 90 ;cos(x) = sin(90 - x)
  sub b, a
  mov a, b
  jmp read_sin
get_sin: ;функция получения синуса направления
  ldi c, 90 ;если направление ≤ 90, ничего не меняем
  sub c, a
  jnc read_sin
a180: ;иначе из 180 вычитаем направление
  ldi c, 180
  sub c, a
  mov a, c
read_sin:
  ldi b, sin ;читаем синус из памяти
  add a, b
  ld a, a
  ld c, output_bank2 ;переходим дальше
  ld d, output_adress2
  jmp set_bank
;все синусы от 0 до 90. старший бит = 1
sin db 0b00000000, 0b00000010, 0b00000100, 0b00000110, 0b00001000,
0b00001011, 0b00001101, 0b00001111, 0b00010001, 0b00010100,
0b00010110, 0b00011000, 0b00011010, 0b00011100, 0b00011110,
0b00100001, 0b00100011, 0b00100101, 0b00100111, 0b00101001,
0b00101011, 0b00101101, 0b00101111, 0b00110001, 0b00110011,
0b00110101, 0b00110111, 0b00111001, 0b00111011, 0b00111101,
0b01000000, 0b01000010, 0b01000100, 0b01000101, 0b01000111,
0b01001001, 0b01001011, 0b01001101, 0b01001110, 0b01010000,
0b01010010, 0b01010100, 0b01010101, 0b01010111, 0b01011001,
0b01011010, 0b01011100, 0b01011101, 0b01011111, 0b01100001,
0b01100010, 0b01100100, 0b01100101, 0b01100110, 0b01100111,
0b01101001, 0b01101010, 0b01101011, 0b01101100, 0b01101101,
0b01101110, 0b01101111, 0b01110001, 0b01110010, 0b01110011,
0b01110100, 0b01110101, 0b01110110, 0b01110111, 0b01110111,
0b01111000, 0b01111001, 0b01111001, 0b01111010, 0b01111010,
0b01111011, 0b01111011, 0b01111100, 0b01111100, 0b01111101,
0b01111101, 0b01111110, 0b01111110, 0b01111110, 0b01111110,
0b01111111, 0b01111111, 0b01111111, 0b01111111, 0b01111111,
0b10000000

void6 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


;BANK 6: BANK DRAW - содкржит кол-во шагов, котрое прошёл каждый луч, и отрисовку стен
add_step: ;добавляем количество шагов, которое прошёл луч
  ld a, i ;читаем прошлое количество шагов, которое прошёл луч
  ldi b, steps
  add b, a
  ld a, b
  inc a ;прибавляем 1
  st a, b ;сохраняем
  jmp end_ray_loop ;переходим к концу обработки луча
clear_start: ;стираем всё с дисплея
  clr a
  ldi b, 32
  ldi d, display
clear_loop:
  st a, d
  inc d
  dec b
  jnz clear_loop
step_start:
  ldi b, steps ;адрес хранения шагов
step_loop:
  st a, k ;сохраняем в счётчик для 6 банка
  ldi c, 4 ;получаем координату, на которой остановился луч
  ldi d, get_ray
  jmp set_bank
  check_win: ;если координата 0x0f, значит луч врезался в выход и стену рисовать не надо
    ldi c, 0x0f
    xor a, c
    jz step_loop_end
  ld a, b ;преобразовываем количество шагов в высоту стены и её адрес
  clr c ;обнуляем количество шагов
  st c, b
  ldi c, 15 ;если шаги превысили 15, назначаем им значение 15
  sub c, a
  jnc set_iter
  ldi a, 15
set_iter:
  ldi c, 16 ;из 16 вычитаем количество шагов
  sub c, a
  st c, save ;сохраняем результат
  ldi c, 64 ;адрес дисплея
  add a, c
  ldi d, 1 ;не помню, как это работает, но оно работает
  and d, a
  add a, d
  ld c, k ;читаем счётчик для 6 банка
  ldi d, 7 ;если счётчик превысил 7, переключаемся на левую половину дисплея
  sub d, c
  jnc set_mask
  inc a
set_mask: ;вычисляем маску стены
  ldi d, 7
  and d, c
  ldi c, 0b10000000
  loop2:
    shr c
    dec d
    jns loop2
  rcl c
  ld d, save ;читаем высоту стены
  st b, save ;сохраняем адрес шагов
  draw_loop: ;рисуем стену
    ld b, a
    or b, c
    st b, a
    inc a
    inc a
    dec d
    jnz draw_loop
  ld b, save ;читаем адрес шагов
step_loop_end:
  inc b ;увеличиваем
  ld a, k ;читаем счётчик для 6 банка
  inc a ;увеличиваем
  ldi c, 16 ;если достигли 16, останавливаемся
  xor c, a
  jnz step_loop
ldi c, 7 ;переходим на чтение клавиши
ldi d, key_read
jmp set_bank
steps db 0, 0, 0, 0, 0, 0, 0, 0, ;число шагов, которое прошёл каждый луч
0, 0, 0, 0, 0, 0, 0, 0, 0
save db 0 ;сохранение
k db 0 ;счётчик для 6 банка
void7 db 0, 0, 0, 0, 0

;BANK 7: BANK KEY - содержит чтение клавиши, движение и повороты игрока и победу
key_read:
  ld a, in_out ;читаем клавишу
  ldi b, KEY_UP ;вверх
  xor b, a
  jz move_player
  ldi b, KEY_RIGHT ;вправо
  xor b, a
  jz turn_right
  ldi b, KEY_LEFT ;влево
  xor b, a
  jnz key_read
;влево
turn_left: ;уменьшаем направление
  ld a, dir
  dec a
  jns save_dir
  ldi a, 23
  jmp save_dir
;вправо
turn_right: ;увеличиваем направление
  ld a, dir
  inc a
  ldi b, 24
  xor b, a
  jnz save_dir
  clr a
save_dir: ;сохраняем направление
  st a, dir
  ld a, coord_player ;переходим к обнулению координат лучей
  ldi c, 4
  ldi d, clear_rays
  jmp set_bank
move_player: ;двигаем игрока вперёд, используя функцию
  ld a, coord_player
  st a, f_coord
  clr a ;умножаем направление на 15
  clr b
  ldi c, 15
  ld d, dir
mul_dir_loop:
  st d, l
  clr d
  add a, c
  adc b, d
  ld d, l
  dec d
  jns mul_dir_loop
clr d
sub a, c
sbb b, d
ldi c, 16
st c, i
ldi c, 7
st c, output_bank1
ldi d, save_coord
st d, output_adress1
clr c
ldi d, move_coord
jmp set_bank
save_coord:
  st a, coord_player ;сохраняем новую координату
  ldi c, 4 ;если не достигли финиша, обнуляем координаты лучей
  ldi d, clear_rays
  ldi b, 0x0f
  xor b, a
  jnz set_bank
inc b ;иначе подключаем терминал и выводим победный текст
st b, in_out
ldi c, win_text
ldi d, 0x3c
win_loop:
  ld a, c
  st a, d
  inc c
  jnz win_loop
hlt ;конец
l db 0 ;счётчик 7 банка
coord_player db 0xe4 ;координата игрока
void8 db 0, 0, 0, 0, 0
win_text db "  You win!\n\n" ;победный текст



;дискета:
;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
