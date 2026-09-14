from farmgui import *
from emulator import *
import time
import pygame
import crossfiledialog
pygame.mixer.pre_init()
pygame.init()

W = pygame.display.Info().current_w
H = pygame.display.Info().current_h

screen = pygame.display.set_mode((W, H))
pygame.display.set_caption("emulator")
keep_going = 1
timer = pygame.time.Clock()

font16 = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 16)
font12 = pygame.font.Font("files/fonts/Better VCR 6.1.ttf", 14)

emu = Emulator()

up_buttons_img = pygame.Surface((W, 30))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="open", font=font16), (0, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="restart", font=font16), (150, 0))
up_buttons_img.blit(get_button_image(150, 30, 0, color=(180, 180, 180), text="show panel", font=font16), (300, 0))
up_buttons_img.blit(get_button_image(W - 450, 30, 0, color=(180, 180, 180)), (450, 0))
left_buttons_img = get_button_image(300, H - 30, 0, color=(180, 180, 180))

open_button_pos = 150
restart_button_pos = 300
show_panel_button_pos = 450

prev_time = 0
steps = 0
tps = 0
draw_panel = 1
while keep_going:
    events = pygame.event.get()
    for event in events:
        if event.type == pygame.QUIT:
            keep_going = 0
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_ESCAPE:
                keep_going = 0
        if event.type == pygame.MOUSEBUTTONDOWN:
            mousepos = pygame.mouse.get_pos()
            if event.button == 1:
                if mousepos[1] < 30:
                    if mousepos[0] < open_button_pos:
                        name = crossfiledialog.open_file(start_dir="files/programs/", filter=["*.asm", "*.txt"])
                        if name != None:
                            emu.filename = name
                            emu.load()
                    elif mousepos[0] < restart_button_pos:
                        emu.load()
                    elif mousepos[0] < show_panel_button_pos:
                        draw_panel = not draw_panel
    #
    #ОБНОВЛЕНИЕ
    #
    current_time = time.time()
    counter = emu.update(events)
    #
    if steps % 10 == 0:
        tps = counter / (current_time - prev_time)
    prev_time = current_time
    #
    #ОТРИСОВКА
    #
    screen.fill((255, 255, 255))
    emu.draw(screen)
    screen.blit(up_buttons_img, (0, 0))
    if draw_panel:
        screen.blit(left_buttons_img, (0, 30))
    #
    render_text(f"fps: {round(timer.get_fps(), 2)}", (5, 40), screen, font=font12, antialias=0)
    render_text(f"tps: {round(tps, 1)}", (5, 60), screen, font=font12, antialias=0)
    if draw_panel:
        render_text("index:   , command:", (5, 80), screen, font=font12, antialias=0)
        render_text(f"      {emu.index}", (5, 80), screen, font=font12, antialias=0)
        render_text(f"                   {hex(emu.read(emu.index))}", (5, 80), screen, font=font12, antialias=0)
        render_text("A:    B:    C:    D:", (5, 100), screen, font=font12, antialias=0)
        render_text(f"  {emu.reg[0]}", (5, 100), screen, font=font12, antialias=0)
        render_text(f"        {emu.reg[1]}", (5, 100), screen, font=font12, antialias=0)
        render_text(f"              {emu.reg[2]}", (5, 100), screen, font=font12, antialias=0)
        render_text(f"                    {emu.reg[3]}", (5, 100), screen, font=font12, antialias=0)
        render_text("Z:    S:    C:    O:", (5, 120), screen, font=font12, antialias=0)
        render_text(f"  {int(emu.flags[0])}", (5, 120), screen, font=font12, antialias=0)
        render_text(f"        {int(emu.flags[1])}", (5, 120), screen, font=font12, antialias=0)
        render_text(f"              {int(emu.flags[2])}", (5, 120), screen, font=font12, antialias=0)
        render_text(f"                    {int(emu.flags[3])}", (5, 120), screen, font=font12, antialias=0)
        render_text(f"bank:      {emu.bank}", (0, 140), screen, font=font12, antialias=0)
        render_text(f"display:   {emu.enable_display}", (0, 160), screen, font=font12, antialias=0)
        render_text(f"indicator: {emu.enable_indicator}", (0, 180), screen, font=font12, antialias=0)
        render_text(f"terminal:  {emu.enable_console}", (0, 200), screen, font=font12, antialias=0) 
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
    steps += 1
    #
    pygame.display.update()
    timer.tick(1000)
pygame.quit()