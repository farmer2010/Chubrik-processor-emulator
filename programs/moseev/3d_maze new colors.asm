start_coord equ 0xe3 ;координата старта игрока
RED equ 1
BLUE equ 2
VIOLET equ 3
start:
ldi c, 4 ;переходим к старту пускания лучей
ldi d, start_rays
set_bank: ;банкинг
  st c, bank
  jmp d
to_move: ;переход на движение координаты после добавления косинуса
  st a, cos ;сохраняем полученный косинус
  ldi c, 2 ;переходим
  st c, bank
  jmp move
ray_wall: ;конец обработки врезания луча в стену
  ld a, walls ;уменьшаем количество лучей, которые не врезались в стену
  dec a
  st a, walls
  ldi c, 4 ;переходим
  st c, bank
  jmp check_end_ray
to_end_ray: ;переход после обработки луча
  ldi c, 4
  st c, bank
  jmp end_ray
read_color_step: ;чтение цвета стены и количества шагов, которое прошёл луч
  ;регистр d уже содержит 5
  ;регистр b уже содержит адрес чтения цвета
  ;регистр c уже содержит адрес чтения количества шагов, которое прошёл луч
  st d, bank ;переключаемся на 5 банк
  ld b, b ;читаем цвет
  ld c, c ;читаем шаги
  inc d ;6 банк
  st d, bank ;переходим обратно
  jmp next_draw
void db 0
player_coord db start_coord ;координата игрока
dir db 0 ;8-битное направление игрока
speed db 0 ;скорость (-1 или 1) синуса или косинуса
speed_x db 0 ;скорость (от -1 до 1) движения по x
speed_y db 0 ;скорость (от -1 до 1) движения по y
sin db 0 ;результат синуса
cos db 0 ;результат косинуса
save1 db 0 ;сохранение важных значений
save2 db 0
walls db 0 ;количество лучей, которые не врезались в стену
i db 0 ;счётчик для больших циклов
;аргументы основной функции движения
f_output_adress_wall db 0 ;адрес перехода при врезании в стену
f_bank_output_load db 0 ;банк всех переходов
f_adress_output db 0 ;адрес перехода в конце функции
f_adress_load_sin db 0 ;адрес чтения синуса
f_adress_load_cos db 0 ;адрес чтения косинуса
f_coord db 0 ;координата
f_dir db 0 ;направление
terminal db 0, 0 ;терминал
in_out db 0b00110001 ;ввод-вывод (подключён цветной дисплей и терминал)
bank db 0 ;банк
display_r db ;заставка
0b00000000, 0b00100011,
0b00000000, 0b00101010,
0b00100010, 0b00101010,
0b00101010, 0b00101010,
0b00100000, 0b00101010,
0b00100000, 0b00101000,
0b00000000, 0b00101000,
0b00001010, 0b00101000,
0b00101010, 0b00101000,
0b00101010, 0b00101000,
0b00100010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00001000
display_b db
0b00000000, 0b00000001,
0b00000000, 0b00000000,
0b00011000, 0b00000000,
0b00000000, 0b00000000,
0b00001111, 0b11000000,
0b00000000, 0b00000000,
0b00001110, 0b00000011,
0b00000000, 0b00000000,
0b00000000, 0b00000110,
0b00000000, 0b00000000,
0b00000000, 0b00000011,
0b00111100, 0b00000000,
0b00000000, 0b11000110,
0b00000000, 0b00000000,
0b00000001, 0b10000011,
0b00000000, 0b00000000
;BANK 1: BANK SIN_COS - содержит обработку направления, синусов и косинусов
raycast: ;функция движения
start_sin:
  ld a, f_dir ;читаем направление
  clr c ;очищаем скорости
  st c, speed_x
  st c, speed_y
  ld d, f_adress_load_sin ;читаем адрес перехода для чтения синуса
  ldi b, 1 ;скорость для движения вправо
  jmp get_sin ;переходим к получению синуса

add_cos: ;добавление косинуса
  ;регистр a уже содержит косинус от направления
  ;регистр b уже содержит старый косинус
  add a, b ;добавляем
  jns to_move ;если результат больше 1, значит нужно перемещать координату по y (старший бит = 1)
  ld c, speed ;читаем скорость
  st c, speed_y ;сохраняем в скорость движения по y
  shl a ;обрезаем старший бит (вычитаем 1)
  shr a
  jmp to_move ;переход

add_sin: ;добавление синуса
  ;регистр a уже содержит синус от направления
  ;регистр b уже содержит старый синус
  add a, b ;добавляем
  jns start_cos ;если результат больше 1, значит нужно перемещать координату по x (старший бит = 1)
  ld c, speed ;читаем скорость
  st c, speed_x ;сохраняем в скорость движения по x
  shl a ;обрезаем старший бит (вычитаем 1)
  shr a

start_cos:
  st a, sin ;сохраняем полученный синус
  ld a, f_dir ;читаем направление
  ld d, f_adress_load_cos ;читаем адрес перехода для чтения косинуса
  ldi b, 0 - 1 ;скорость для движения вверх

get_cos: ;получение косинуса
  ldi c, 45 ;cos(a) = sin(45 - a)
  sub c, a
  mov a, c
  jnc get_sin ;если результат положительный, переходим на получение синуса
  ldi c, 180 ;иначе прибавляем 180 и получаем положительное число
  add a, c

get_sin:
  ldi c, 90 ;если направление больше 90, значит двигаться нужно в противоположную сторону
  sub c, a
  jc neg_sin
pos_sin: ;направление меньше 90 (движение вправо)
  st b, speed ;сохраняем скорость для движения в нужную сторону
  jmp read_sin
neg_sin:
  neg b ;скорость движения в противоположную сторону
  st b, speed
  ldi c, 90 ;вычитаем 90, чтобы направление было от 0 до 90
  sub a, c
read_sin:
  ldi c, 45 ;если полученное направление меньше 45, переходим сразу к чтению
  sub c, a
  jnc read
  ldi c, 90 ;иначе из 90 вычитаем направление и получаем новое значение от 0 до 45
  sub c, a
  mov a, c
read:
  ldi c, table_sin ;читаем значение синуса
  add a, c
  ld a, a
  ld c, f_bank_output_load ;читаем банк перехода
  jmp set_bank ;переходим на чтение синуса/косинуса

;все значения синусов от 0 до 45 (старший бит = 1)
table_sin db 0b00000000, 0b00000100, 0b00001000, 0b00001101, 0b00010001,
0b00010110, 0b00011010, 0b00011110, 0b00100011, 0b00100111,
0b00101011, 0b00101111, 0b00110011, 0b00110111, 0b00111011,
0b01000000, 0b01000100, 0b01000111, 0b01001011, 0b01001110,
0b01010010, 0b01010101, 0b01011001, 0b01011100, 0b01011111,
0b01100010, 0b01100101, 0b01100111, 0b01101010, 0b01101100,
0b01101110, 0b01110001, 0b01110011, 0b01110101, 0b01110111,
0b01111000, 0b01111001, 0b01111010, 0b01111011, 0b01111100,
0b01111101, 0b01111110, 0b01111110, 0b01111111, 0b01111111,
0b10000000
;BANK 2: BANK MOVE - содержит движение координаты
;BANK SETTINGS_PLAYER - содержит настройки для игрока
;BANK MOVE
move:
  ld a, f_coord ;читаем координату
  mov b, a ;копируем
  ldi d, 0x0f ;в a - x
  and a, d
  shr b ;в b - y
  shr b
  shr b
  shr b
move_x:
  ld c, speed_x ;читаем скорость движения по x
  add a, c ;добавляем
  test c
  jz move_y ;если скорость 0, пропускаем проверку
  js move_left ;если отрицательная, переходим на проверку для неё
move_right: ;проверка для положительной скорости
  and a, d ;0 получается только если 15 + 1 = 16, 16 & 15 = 0
  jz wall_edge ;если 0 есть, значит переходим к попаданию на границу карты
  jmp move_y ;иначе переходим к движению по y
move_left: ;проверка для отрицательной скорости
  test a ;флаг s получается только если 0 + (-1) = -1
  js wall_edge ;если флаг s есть, значит переходим к попаданию на границу карты
move_y: ;то же самое, что и для x, но для y
  ld c, speed_y
  add b, c
  test c
  jz move_end
  js move_up
move_down:
  and b, d
  jnz move_end
wall_edge: ;обработка попадания на границу карты
  ldi a, BLUE ;границы карты синего цвета
  ld c, f_bank_output_load ;читаем банк перехода
  ld d, f_output_adress_wall ;читаем адрес перехода для стены
  jmp set_bank ;переходим
move_up:
  test b
  js wall_edge
move_end:
  st a, save1 ;сохраняем новые координаты
  st b, save2
  ldi c, 7 ;превращаем их в позицию и адрес
  and c, a
  shr a
  shr a
  shr a
  shl b
  add b, a
  ldi a, 0b10000000
  shr_loop:
    shr a
    dec c
    jns shr_loop
  rcl a
  ldi c, 3 ;переходим на проверку столкновения со стенами
  ldi d, check_wall
  jmp set_bank
;BANK SETTINGS_PLAYER
set_settings_player:
  ldi a, 7 ;банк всех переходов
  st a, f_bank_output_load
  ldi a, check_game_over ;если врезаемся, проверяем на финиш
  st a, f_output_adress_wall
  ldi a, save_coord_player ;после перемещения сохраняем новую координату
  st a, f_adress_output
  ldi a, player_load_sin ;чтение синуса игрока
  st a, f_adress_load_sin
  ldi a, player_load_cos ;чтение косинуса игрока
  st a, f_adress_load_cos
  ld a, player_coord ;координата игрока
  st a, f_coord
  ld a, dir ;8-битное направление игрока
  st a, f_dir
  clr c ;переходим к старту перемещения
  ldi d, raycast
  jmp set_bank

void3 db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0

;BANK 3: BANK MAP - содержит карту и проверку на столкновение с ней
check_wall:
  ldi d, ver ;карта вертикальных линий
  add d, b ;добавляем адрес
  ld c, d ;читаем байт
  and c, a ;если попали на стену, значит сохраняем красный цвет
  jz check_hor
  ldi a, RED
  jmp wall_jmp
check_hor: ;то же самое, что и для вертикальной, но для горизонтальной
  ldi d, hor
  add d, b
  ld c, d
  and c, a
  jz check_win
  ldi a, BLUE ;у горизонтальных стен синий цвет
  jmp wall_jmp
check_win:
  shr a ;позиция 0b00000001 - позиция финиша
  jnc save_jmp
check_win_adress:
  dec b ;адрес 1 - адрес финиша
  jnz save_jmp
  ldi a, VIOLET ;у финиша фиолетовый цвет
wall_jmp: ;переход в случае попадания на стену
  ld c, f_bank_output_load
  ld d, f_output_adress_wall
  jmp set_bank
save_jmp:
  ld a, save1 ;читаем координаты
  ld b, save2
  shl b ;сохраняем в один байт
  shl b
  shl b
  shl b
  or a, b
  ld c, f_bank_output_load ;читаем банк перехода
  ld d, f_adress_output ;читаем адрес перехода в конце функции
  jmp set_bank ;переходим

void4 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

hor db ;карта горизонтальных линий
0b00000000, 0b00000000,
0b00000000, 0b00000000,
0b00011000, 0b00000000,
0b00000000, 0b00000000,
0b00001111, 0b11000000,
0b00000000, 0b00000000,
0b00001110, 0b00000011,
0b00000000, 0b00000000,
0b00000000, 0b00000110,
0b00000000, 0b00000000,
0b00000000, 0b00000011,
0b00111100, 0b00000000,
0b00000000, 0b11000110,
0b00000000, 0b00000000,
0b00000001, 0b10000011,
0b00000000, 0b00000000
ver db ;карта вертикальных линий
0b00000000, 0b00100010,
0b00000000, 0b00101010,
0b00100010, 0b00101010,
0b00101010, 0b00101010,
0b00100000, 0b00101010,
0b00100000, 0b00101000,
0b00000000, 0b00101000,
0b00001010, 0b00101000,
0b00101010, 0b00101000,
0b00101010, 0b00101000,
0b00100010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00101000,
0b00000010, 0b00001000

;BANK 4: BANK RAYS 1 - содержит пускание лучей, их координаты и конец движения
start_rays:
  ldi b, 16 ;обновляем количество лучей, которые не врезались в стену
  st b, walls
  dec b ;15
start_ray:
  st b, i ;сохраняем номер луча
set_settings:
  ldi a, 5 ;банк всех переходов
  st a, f_bank_output_load
  ldi a, save_color ;если луч попадёт в стену, цвет сохраняем
  st a, f_output_adress_wall
  ldi a, next_step ;адрес в конце функции
  st a, f_adress_output
  ldi a, ray_load_sin ;адрес загрузки синуса луча
  st a, f_adress_load_sin
  ldi a, ray_load_cos ;адрес загрузки косинуса луча
  st a, f_adress_load_cos
  ldi c, coord_rays ;адрес координат лучей
  add c, b ;добавляем номер луча и получаем адрес координаты для луча
  ld a, c ;читаем
  st a, f_coord ;сохраняем
  shl b ;умножаем на 2
  ldi a, 165 ;прибавляем 165 и получаем направление от -15 до 15
  add a, b
  clr b ;старший байт
  ld c, dir ;читаем направление
  add a, c ;добавляем
  jnc dir_mod
  inc b ;если направление превысило 256, то старший байт = 1
dir_mod: ;вычисляем остаток от деления направления на 180
  ldi c, 179
  clr d
  sub c, a
  sbb d, b
  jnc set_dir
  ldi c, 180
  clr d
  sub a, c
  sbb b, d
  jmp dir_mod
set_dir:
  st a, f_dir ;сохраняем направление
  clr c ;переходим к старту функции
  ldi d, raycast
  jmp set_bank

end_ray:
  ldi c, coord_rays ;сохраняем новую координату
  add c, b
  st a, c
check_end_ray:
  dec b ;следующий луч
  jns start_ray ;если лучи не закончились, продолжаем
  ld a, walls ;иначе читаем количество лучей, которые не врезались в стену
  test a ;если их не 0, значит свободные лучи ещё остались
  jnz start_rays ;поэтому переходим на дальнейшее движение лучей
  ldi c, 6 ;если все лучи врезались, переходим к отрисовке
  ldi d, clear_display
  jmp set_bank

clear_coord_rays: ;сбрасывание координат лучей
  ;регистр a уже содержит координату
  ldi b, clear_coord_rays_loop ;адрес цикла
  ldi d, coord_rays ;адрес координат лучей
clear_coord_rays_loop:
  st a, d ;сбрасываем координату
  inc d ;следующая
  jnz b ;если не закончились, повторяем
clr a ;очищаем
ldi c, 5 ;переходим к сбросу других параметров
ldi d, clear
jmp set_bank

void5 db 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0

;координаты лучей
coord_rays db start_coord, start_coord, start_coord, start_coord,
start_coord, start_coord, start_coord, start_coord,
start_coord, start_coord, start_coord, start_coord,
start_coord, start_coord, start_coord, start_coord
;BANK 5: BANK RAYS 2 - содержит много параметров лучей и их обработку
ray_load_sin: ;чтение синуса у луча
  ld b, i ;номер луча
  ldi c, sin_rays ;адрес синусов
  add c, b
  ld b, c ;читаем синус
  clr c ;переходим на добавление
  ldi d, add_sin
  jmp set_bank
ray_load_cos: ;чтение косинуса у луча
  ;то же самое, что и чтение синуса, но косинус
  ld b, i
  ldi c, cos_rays
  add c, b
  ld b, c
  clr c
  ldi d, add_cos
  jmp set_bank

save_color: ;сохранение цвета, если луч врезался в стену
  ld b, i ;читаем номер
  ldi d, rays_color ;адрес цветов
  add d, b
  st a, d ;сохраняем цвет
  jmp ray_wall ;переход

next_step: ;конец функции
  ld b, i ;читаем номер
  ldi d, sin_rays ;адрес синусов
  add d, b
  ld c, sin ;читаем синус
  st c, d ;сохраняем
  ldi d, cos_rays ;адрес косинусов
  add d, b
  ld c, cos ;читаем косинус
  st c, d ;сохраняем
  ldi d, rays_steps ;адрес шагов, которое прошли лучи
  add d, b
  ld c, d ;читаем
  inc c ;увеличиваем
  st c, d ;сохраняем
  jmp to_end_ray ;переход

clear: ;очищаем другие параметры
  ;регистр a пустой
  ldi b, clear_loop ;адрес цикла
  ldi d, rays_steps ;адрес параметров
clear_loop:
  st a, d ;сбрасываем
  inc d ;следующий
  jnz b ;если не закончились, повторяем
jmp start ;переходим к самому началу

void6 db 0, 0, 0

;цвета стен, в которые врезались лучи
rays_color db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0
;количество шагов, которое прошёл каждый луч
rays_steps db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0
;синусы лучей
sin_rays db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0
;косинусы лучей
cos_rays db 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0

;BANK 6: BANK DRAW - содержит отрисовку стен
clear_display:
  clr a ;очищаем
  ldi b, clear_display_loop ;адрес цикла
  ldi d, display_r ;дисплей
clear_display_loop:
  st a, d ;очищаем байт дисплея
  inc d ;следующий байт
  jns b ;если не закончились, повторяем
draw:
  st a, i ;сохраняем счётчик
  ldi b, rays_color ;адрес чтения цвета
  add b, a
  ldi c, rays_steps ;адрес чтения количества шагов
  add c, a
  ldi d, 5 ;банк чтения
  jmp read_color_step ;переходим на чтение
  next_draw:
    st b, color ;сохраняем цвет
    ldi d, 15 ;если количество шагов больше 15, назначаем 15
    sub d, c
    jnc i_to_pos
    ldi c, 15
  i_to_pos:
    ldi d, 7 ;вычисляем позицию в байте
    and d, a
    ldi b, 0b10000000
    draw_shr_loop:
      shr b
      dec d
      jns draw_shr_loop
    rcl b
  ldi d, 16 ;из 16 вычитаем количество шагов (чем меньше прошёл луч, тем ближе стена)
  sub d, c
  mov c, d
  st c, iter ;сохраняем
check_red:
  ld d, color ;читаем цвет
  shr d ;если красного пигмента нет, переходим на проверку синего
  jnc check_blue
  ldi d, check_blue ;если есть, сохраняем адрес перехода после вывода стены
  st d, next
  ldi d, display_r + 16 ;красный дисплей
  jmp draw_wall
check_blue: ;то же самое, что и для красного, но для синего пигмента
  ld d, color
  shr d
  shr d
  jnc draw_end
  ldi d, draw_end
  st d, next
  ldi d, display_b + 16
  jmp draw_wall
draw_end:
  inc a ;следующий луч
  ldi b, 16 ;если не закончились, повторяем
  xor b, a
  jnz draw
ldi c, 7 ;переходим на чтение клавиши
ldi d, key_read
jmp set_bank
draw_wall:
  shr c ;обрезаем младший бит
  shl c
  sub d, c ;вычитаем из центра дисплея
  shr a ;при необходимости переключаемся на правую половину дисплея
  shr a
  shr a
  add d, a
  ld c, iter ;читаем количество итераций
draw_wall_loop:
  ld a, d ;читаем байт
  or a, b ;зажигаем пиксель
  st a, d ;выводим
  inc d ;следующий байт ниже
  inc d
  dec c ;повторяем количество итераций
  jnz draw_wall_loop
ld a, i ;читаем номер
ld c, iter ;читаем количество итераций
ld d, next ;читаем адрес перехода
jmp d ;переходим по адресу
next db 0 ;адрес перехода после вывода пигмента стены
iter db 0 ;количество итераций
color db 0 ;цвет
void7 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0
;BANK 7: BANK PLAYER - содержит обработку игрока
key_read:
  ld a, in_out ;читаем ввод
  ldi b, 0x11 ;клавиша влево
  sub a, b
  jz left
  dec a ;клавиша вверх
  jz move_player
  dec a ;клавиша вправо
  jnz key_read
right:
  ld a, player_dir + 1 ;читаем младший байт направления
  ld b, player_dir ;читаем старший байт направления
  ldi c, 15 ;добавляем 15
  clr d
  add a, c
  adc b, d
  ldi c, 359 - 256 ;если превысили 359, обнуляем
  inc d
  sub c, a
  sbb d, b
  jnc save_dir
  clr a
  clr b
  jmp save_dir
left:
  ld a, player_dir + 1 ;читаем младший байт направления
  ld b, player_dir ;читаем старший байт направления
  ldi c, 15 ;вычитаем 15
  clr d
  sub a, c
  sbb b, d
  jnc save_dir ;если меньше 0, задаём направление 360 - 15
  ldi a, 360 - 15 - 256
  ldi b, 1
save_dir:
  st a, player_dir + 1 ;сохраняем 16-битное направление
  st b, player_dir
  shr b ;делим на 2 и получаем 8-битное направление
  rcr a
  st a, dir ;сохраняем
jmp_clear:
  ld a, player_coord ;читаем координату
  ldi c, 4 ;переходим на обновление параметров лучей
  ldi d, clear_coord_rays
  jmp set_bank
move_player: ;движение игрока
  ldi c, 2 ;переходим на задание настроек
  ldi d, set_settings_player
  jmp set_bank
player_load_sin:
  ld b, sin_player ;чтение синуса игрока
  clr c
  ldi d, add_sin
  jmp set_bank
player_load_cos:
  ld b, cos_player ;чтение косинуса игрока
  clr c
  ldi d, add_cos
  jmp set_bank
check_game_over:
  dec a ;если в a значение 3, значит игрок врезался в финиш
  dec a
  dec a
  jz game_over ;поэтому выводим победный текст
  jmp jmp_clear
save_coord_player:
  st a, player_coord ;сохраняем новую координату игрока
  ld a, sin ;сохраняем новый синус игрока
  st a, sin_player
  ld a, cos ;сохраняем новый косинус игрока
  st a, cos_player
  jmp jmp_clear ;переходим на обновление параметров лучей
game_over:
  ldi b, game_over_loop ;адрес цикла
  ldi c, text_game_over ;адрес текста
  ldi d, terminal ;адрес вывода
game_over_loop:
  ld a, c ;читаем символ
  st a, d ;выводим
  inc c ;следующий символ
  jnz b ;если не закончились, повторяем
hlt ;конец
player_dir db 0, 0 ;16-битное направление игрока
sin_player db 0 ;синус игрока
cos_player db 0 ;косинус игрока
text_game_over db "  You win!" ;победный текст


;дискета:
;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
