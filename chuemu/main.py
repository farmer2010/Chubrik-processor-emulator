from farmgui import *
from emulator import *
import time
import pygame
pygame.mixer.pre_init()
pygame.init()

W = pygame.display.Info().current_w
H = pygame.display.Info().current_h

big_font = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 80)
small_font = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 10)

screen = pygame.display.set_mode((W, H))
pygame.display.set_caption("emulator")
keep_going = 1
pause = 1
timer = pygame.time.Clock()

emu = Emulator()

speed = 20

console_scale = 8

prev_time = 0
steps = 0
tps = 0
while keep_going:
    events = pygame.event.get()
    for event in events:
        if event.type == pygame.QUIT:
            keep_going = 0
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                keep_going = 0
            if event.key == pygame.K_F1:
                pause = not pause
            if event.key == pygame.K_F2:
                emu = Emulator()
            if event.key == pygame.K_F3:
                if emu.read(emu.index) == 0x02:
                    emu.index = (emu.index + 1) % 256
                else:
                    emu.update(events)
    #
    #ОБНОВЛЕНИЕ
    #
    current_time = time.time()
    if not pause:
        counter = emu.update(events)
    else:
        counter = 0
    #
    if steps % 10 == 0:
        tps = counter / (current_time - prev_time)
    prev_time = current_time
    #
    #ОТРИСОВКА
    #
    emu.update_display()
    screen.fill((255, 255, 255))
    if pause:
        render_text("[PAUSED]", (W / 2, 0), screen, color=(255, 0, 0), font_size=50, centerx="center")
    #
    render_text(f"index: {emu.index}, command: {hex(emu.read(emu.index))}", (0, 0), screen)
    render_text(f"A: {emu.reg[0]}, B: {emu.reg[1]}, C: {emu.reg[2]}, D: {emu.reg[3]}", (0, 20), screen)
    render_text(f"Z: {int(emu.flags[0])}, S: {int(emu.flags[1])}, C: {int(emu.flags[2])}, O: {int(emu.flags[3])}", (0, 40), screen)
    render_text(f"bank: {emu.bank}, display: {emu.enable_display}, indicator: {emu.enable_indicator}, terminal: {emu.enable_console}", (0, 60), screen)
    fps = round(timer.get_fps(), 2)
    render_text(f"fps: {fps}", (0, 80), screen, (255, 0, 0))
    render_text(f"tps: {round(tps, 1)}", (0, 100), screen, (255, 0, 0))
    #
    '''for i in range(128):
        render_text(str(i) + ":  " + str(emu.memory[i]), (300 + (i // 64) * 100, (i % 64) * 12), screen, font=small_font)#b0
        if emu.index == i:
            pygame.draw.circle(screen, (255, 0, 0), (280 + (i // 64) * 100 + 8, (i % 64) * 12 + 8), 5)
        #
        render_text(str(i + 128) + ":  " + str(emu.memory[i + 128]), (600 + (i // 64) * 100, (i % 64) * 12), screen, font=small_font)#b1
        if emu.index == i + 128 and emu.bank == 1:
            pygame.draw.circle(screen, (255, 0, 0), (580 + (i // 64) * 100 + 8, (i % 64) * 12 + 8), 5)
        #
        #render_text(str(i + 32 * 128) + ":  " + str(emu.memory[i + 32 * 128]), (900 + (i // 64) * 100, (i % 64) * 16), screen, font=font)#b32
        #if emu.index == i + 128 and emu.bank == 32:
        #    pygame.draw.circle(screen, (255, 0, 0), (880 + (i // 64) * 100 + 8, (i % 64) * 16 + 8), 5)'''
    #
    pygame.draw.rect(screen, (0, 0, 0), ((W * 0.75 - 258, H / 2 - 258, 516, 516)))
    screen.blit(emu.display, (W * 0.75 - 256, H / 2 - 256))
    indicator = emu.indicator_b1 + emu.indicator_b2 * 256
    if emu.enable_indicator == 2 and indicator > 32767:
        indicator -= 65536
    render_text(str(indicator), (W * 0.75 - 256, H / 2 + 260), screen, font=big_font, color=(255, 0, 0))
    pygame.draw.rect(screen, (0, 0, 0), (W * 0.25 - emu.console_w * 6 * console_scale / 2 - 2, H / 2 - emu.console_h * 8 * console_scale / 2 - 2, emu.console_w * 6 * console_scale + 4, emu.console_h * 8 * console_scale + 4 + 2 * console_scale))
    pygame.draw.rect(screen, (255, 255, 255), (W * 0.25 - emu.console_w * 6 * console_scale / 2, H / 2 + emu.console_h * 8 * console_scale / 2, emu.console_w * 6 * console_scale, 2 * console_scale))
    pygame.draw.rect(screen, (0, 0, 0), (W * 0.25 - emu.console_w * 6 * console_scale / 2 + emu.console_index * 6 * console_scale, H / 2 + (emu.console_h * 8 + 1) * console_scale / 2, 6 * console_scale, console_scale))
    for x in range(emu.console_w):
        for y in range(emu.console_h):
            screen.blit(emu.console[y][x], (W * 0.25 - emu.console_w * 6 * console_scale / 2 + x * 6 * console_scale, H / 2 - emu.console_h * 8 * console_scale / 2 + y * 8 * console_scale))
    #
    steps += 1
    #
    pygame.display.update()
    timer.tick(1000)
pygame.quit()