import pygame
pygame.init()

def render_text(text, pos, screen, color=(0, 0, 0), centerx="left", centery="up", font=None, font_name=None, font_size=24):#отрисовка текста на экране
    if font == None:
        font = pygame.font.SysFont(font_name, font_size)
    text_img = font.render(text, True, color)
    text_rect = text_img.get_rect()
    if centerx == "left":
        text_rect.x = pos[0]
    elif centerx == "center":
        text_rect.centerx = pos[0]
    elif centerx == "right":
        text_rect.x = pos[0] - text_img.get_width()
    if centery == "up":
        text_rect.y = pos[1]
    elif centery == "center":
        text_rect.centery = pos[1]
    elif centery == "down":
        text_rect.y = pos[1] - text_img.get_height()
    screen.blit(text_img, text_rect)

def render_colored_text(text, pos, screen, base_color=(0, 0, 0), centerx="left", centery="up", font=None, font_name=None, font_size=24, colors=[]):#отрисовка текста на экране
    if font == None:
        font = pygame.font.SysFont(font_name, font_size)
    w_offs = 0
    for i in range(len(colors)):
        if i > 0:
            t = text[colors[i - 1][1]:colors[i][0]]
        else:
            t = text[0:colors[i][0]]
        render_text(t, (pos[0] + w_offs, pos[1]), screen, color=base_color, centery=centery, font=font, font_name=font_name, font_size=font_size)
        ti = font.render(t, True, base_color)
        w_offs += ti.get_width()
        #
        render_text(text[colors[i][0]:colors[i][1]], (pos[0] + w_offs, pos[1]), screen, color=colors[i][2], centery=centery, font=font, font_name=font_name, font_size=font_size)
        ti = font.render(text[colors[i][0]:colors[i][1]], True, base_color)
        w_offs += ti.get_width()
        #
        if i == len(colors) - 1:
            render_text(text[colors[i][1]:len(text)], (pos[0] + w_offs, pos[1]), screen, color=base_color, centery=centery, font=font, font_name=font_name, font_size=font_size)
    if colors == []:
        render_text(text, pos, screen, base_color, centerx, centery, font, font_name, font_size)
