import pygame
pygame.init()

def render_text(text, pos, screen, color=(0, 0, 0), centerx="left", centery="up", font=None, font_name=None, font_size=24, antialias=1):#отрисовка текста на экране
    if font == None:
        font = pygame.font.SysFont(font_name, font_size)
    text_img = font.render(text, antialias, color)
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

def get_button_image(w, h, type, color, offset=3, ch=30, text="", font=pygame.font.SysFont(None, 24), font_color=(0, 0, 0)):
    img = pygame.Surface((w, h), pygame.SRCALPHA)
    if type == 0 or type == 2:
        img.fill((min(color[0] + ch, 255), min(color[1] + ch, 255), min(color[2] + ch, 255)))
        pygame.draw.rect(img, (max(color[0] - ch, 0), max(color[1] - ch, 0), max(color[2] - ch, 0)), (offset, offset, w - offset, h - offset))
        pygame.draw.rect(img, color, (offset, offset, w - offset * 2, h - offset * 2))
    elif type == 1:
        img.fill((max(color[0] - ch, 0), max(color[1] - ch, 0), max(color[2] - ch, 0)))
        pygame.draw.rect(img, (min(color[0] + ch, 255), min(color[1] + ch, 255), min(color[2] + ch, 255)), (offset, offset, w - offset, h - offset))
        pygame.draw.rect(img, color, (offset, offset, w - offset * 2, h - offset * 2))
    render_text(text, (w/2, h/2), img, font_color, centerx="center", centery="center", font=font)
    return(img)

def get_text_box_image(w, h, color, offset=3, ch=0.1):
    img = pygame.Surface((w, h), pygame.SRCALPHA)
    img.fill((min(int(color[0] * (1 + ch*2)), 255), min(int(color[1] * (1 + ch*2)), 255), min(int(color[2] * (1 + ch*2)), 255)))
    pygame.draw.rect(img, (min(int(color[0] * (1 - ch)), 255), min(int(color[1] * (1 - ch)), 255), min(int(color[2] * (1 - ch)), 255)), (offset, offset, w - offset*2, h - offset*2))
    pygame.draw.rect(img, (min(int(color[0] * (1 + ch)), 255), min(int(color[1] * (1 + ch)), 255), min(int(color[2] * (1 + ch)), 255)), (offset*2, offset*2, w - offset*3, h - offset*3))
    pygame.draw.rect(img, color, (offset*2, offset*2, w - offset*4, h - offset*4))
    return(img)