from farmgui.utils import *
import pygame
pygame.init()

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

def get_text_box_image(w, h, color, offset=3, ch=30):
    img = pygame.Surface((w, h), pygame.SRCALPHA)
    img.fill((min(color[0] + ch*2, 255), min(color[1] + ch*2, 255), min(color[2] + ch*2, 255)))
    pygame.draw.rect(img, (max(color[0] - ch, 0), max(color[1] - ch, 0), max(color[2] - ch, 0)), (offset, offset, w - offset*2, h - offset*2))
    pygame.draw.rect(img, (min(color[0] + ch, 255), min(color[1] + ch, 255), min(color[2] + ch, 255)), (offset*2, offset*2, w - offset*3, h - offset*3))
    pygame.draw.rect(img, color, (offset*2, offset*2, w - offset*4, h - offset*4))
    return(img)

def get_slider_image(w, h, color, offset=3, ch=30):
    img = pygame.Surface((w, h), pygame.SRCALPHA)
    img.fill((min(color[0] + ch * 2, 255), min(color[1] + ch * 2, 255), min(color[2] + ch * 2, 255)))
    pygame.draw.rect(img, (max(color[0] - ch, 0), max(color[1] - ch, 0), max(color[2] - ch, 0)), (offset, offset, w - offset * 2, h - offset * 2))
    pygame.draw.rect(img, (min(color[0] + ch, 255), min(color[1] + ch, 255), min(color[2] + ch, 255)), (offset * 2, offset * 2, w - offset * 3, h - offset * 3))
    pygame.draw.rect(img, color, (offset * 2, offset * 2, w - offset * 4, h - offset * 4))
    return (img)

'''def get_button_image(w, h, type, color, offset=3, ch=30, text="", font=pygame.font.SysFont(None, 24), font_color=(0, 0, 0)):
    img = pygame.Surface((w, h), pygame.SRCALPHA)
    #
    c1 = (0, 0, 0)
    c2 = (max(color[0] - ch, 0), max(color[1] - ch, 0), max(color[2] - ch, 0))
    c3 = (min(color[0] + ch, 255), min(color[1] + ch, 255), min(color[2] + ch, 255))
    #
    pygame.draw.rect(img, c1, (offset, 0, w - offset * 2, offset))
    pygame.draw.rect(img, c1, (offset, h - offset, w - offset * 2, offset))
    pygame.draw.rect(img, c1, (0, offset, offset, h - offset * 2))
    pygame.draw.rect(img, c1, (w - offset, offset, offset, h - offset * 2))
    #
    if type == 0:
        pygame.draw.rect(img, c2, (offset, h - offset * 2, w - offset * 2, offset))
        #
        pygame.draw.rect(img, color, (offset, offset, w - offset * 2, h - offset * 3))
        #
        pygame.draw.rect(img, c3, (offset * 2, offset, w - offset * 4, offset))
        pygame.draw.rect(img, c3, (offset * 2, h - offset * 3, w - offset * 4, offset))
        pygame.draw.rect(img, c3, (offset, offset * 2, offset, h - offset * 5))
        pygame.draw.rect(img, c3, (w - offset * 2, offset * 2, offset, h - offset * 5))
    elif type == 1:
        pygame.draw.rect(img, color, (offset, offset, w - offset * 2, h - offset * 2))
        #
        pygame.draw.rect(img, c3, (offset * 2, offset, w - offset * 4, offset))
        pygame.draw.rect(img, c3, (offset * 2, h - offset * 2, w - offset * 4, offset))
        pygame.draw.rect(img, c3, (offset, offset * 2, offset, h - offset * 4))
        pygame.draw.rect(img, c3, (w - offset * 2, offset * 2, offset, h - offset * 4))
        #
        pygame.draw.rect(img, c2, (offset * 3, offset * 2, w - offset * 6, offset))
        pygame.draw.rect(img, c2, (offset * 3, h - offset * 3, w - offset * 6, offset))
        pygame.draw.rect(img, c2, (offset * 2, offset * 3, offset, h - offset * 6))
        pygame.draw.rect(img, c2, (w - offset * 3, offset * 3, offset, h - offset * 6))
    render_text(text, (w / 2, h / 2), img, font_color, centerx="center", centery="center", font=font)
    return (img)

def get_text_box_image(w, h, color, offset=3, ch=30):
    img = pygame.Surface((w, h), pygame.SRCALPHA)
    #
    c1 = (0, 0, 0)
    c2 = (max(color[0] - ch, 0), max(color[1] - ch, 0), max(color[2] - ch, 0))
    c3 = (int(max(color[0] - ch*1.5, 0)), int(max(color[1] - ch*1.5, 0)), int(max(color[2] - ch*1.5, 0)))
    c4 = (min(color[0] + ch*2, 255), min(color[1] + ch*2, 255), min(color[2] + ch*2, 255))
    #
    pygame.draw.rect(img, c4, (offset, 0, w - offset * 2, offset))
    pygame.draw.rect(img, c4, (offset, h - offset, w - offset * 2, offset))
    pygame.draw.rect(img, c4, (0, offset, offset, h - offset * 2))
    pygame.draw.rect(img, c4, (w - offset, offset, offset, h - offset * 2))
    #
    pygame.draw.rect(img, c1, (offset * 2, offset, w - offset * 4, offset))
    pygame.draw.rect(img, c1, (offset * 2, h - offset * 2, w - offset * 4, offset))
    pygame.draw.rect(img, c1, (offset, offset * 2, offset, h - offset * 4))
    pygame.draw.rect(img, c1, (w - offset * 2, offset * 2, offset, h - offset * 4))
    #
    pygame.draw.rect(img, color, (offset * 2, offset * 2, w - offset * 4, h - offset * 4))
    #
    pygame.draw.rect(img, c3, (offset, offset, offset, offset))
    pygame.draw.rect(img, c3, (offset * 2, offset * 2, offset, offset))
    pygame.draw.rect(img, c3, (offset, h - offset * 2, offset, offset))
    pygame.draw.rect(img, c3, (offset * 2, h - offset * 3, offset, offset))
    pygame.draw.rect(img, c3, (w - offset * 2, offset, offset, offset))
    pygame.draw.rect(img, c3, (w - offset * 3, offset * 2, offset, offset))
    pygame.draw.rect(img, c3, (w - offset * 2, h - offset * 2, offset, offset))
    pygame.draw.rect(img, c3, (w - offset * 3, h - offset * 3, offset, offset))
    #
    pygame.draw.rect(img, c2, (offset * 3, offset * 2, w - offset * 6, offset))
    #
    return(img)

def get_slider_image(w, h, color, offset=3, ch=30):
    return(get_text_box_image(w, h, color, offset, ch))'''