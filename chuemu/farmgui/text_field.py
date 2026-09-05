from farmgui.slider import *
from farmgui.button import *
from farmgui.panel import *
from farmgui.text_field_main import *
import pygame
pygame.init()

class TextField(Panel):
    def __init__(
            self,
            rect,
            text="",
            font=None,
            font_name="times new roman",
            font_size=30,
            font_color=(0, 0, 0),
            text_x=10,
            text_y=10,
            enabled_symbols=None,
            disabled_symbols=[],
            sliders_height=20,
            **kwargs
        ):
        Panel.__init__(self, rect, **kwargs)
        #
        self.inactive_image = kwargs.get("inactive_image") if kwargs.get("inactive_image") != None else get_text_box_image(self.rect.w, self.rect.h, (90, 90, 90))
        self.hover_image = kwargs.get("hover_image") if kwargs.get("hover_image") != None else get_text_box_image(self.rect.w, self.rect.h, (90, 90, 90))#120
        self.background_image = self.inactive_image
        #
        self.main = TextFieldMain(
            (text_x, text_y, self.rect.w - text_x * 2 - sliders_height, self.rect.h - text_x * 2 - sliders_height),
            text=text,
            font=font,
            font_name=font_name,
            font_size=font_size,
            font_color=font_color,
            enabled_symbols=enabled_symbols,
            disabled_symbols=disabled_symbols
        )
        self.main.onclick = kwargs.get("onclick")
        self.main.onclick_params = kwargs.get("onclick_params")
        self.main.onchange = kwargs.get("onchange")
        self.main.onchange_params = kwargs.get("onchange_params")
        self.main.onsubmit = kwargs.get("onsubmit")
        self.main.onsubmit_params = kwargs.get("onsubmit_params")
        self.main.color_text = kwargs.get("color_text")
        self.add(self.main)
        #
        inv_img = pygame.Surface((10, 10), pygame.SRCALPHA)
        inv_img.fill((0, 0, 0, 0))
        inactive_hor_c_image = pygame.Surface((sliders_height * 1.5, sliders_height - 6))
        inactive_hor_c_image.fill((130, 130, 130))
        hover_hor_c_image = pygame.Surface((sliders_height * 1.5, sliders_height - 6))
        hover_hor_c_image.fill((150, 150, 150))
        inactive_vert_c_image = pygame.Surface((sliders_height - 6, sliders_height * 1.5))
        inactive_vert_c_image.fill((130, 130, 130))
        hover_vert_c_image = pygame.Surface((sliders_height - 6, sliders_height * 1.5))
        hover_vert_c_image.fill((150, 150, 150))
        self.hor_slider = Slider(
            (3, self.rect.h - sliders_height - 3, self.rect.w - sliders_height, sliders_height),
            (sliders_height * 1.5, sliders_height - 6),
            inactive_image=inv_img,
            hover_image=inv_img,
            c_inactive_image=inactive_hor_c_image,
            c_hover_image=hover_hor_c_image,
        )
        self.add(self.hor_slider)
        self.vert_slider = Slider(
            (self.rect.w - sliders_height - 3, 3, sliders_height, self.rect.h - sliders_height),
            (sliders_height - 6, sliders_height * 1.5),
            inactive_image=inv_img,
            hover_image=inv_img,
            c_inactive_image=inactive_vert_c_image,
            c_hover_image=hover_vert_c_image,
            vertical=True
        )
        self.add(self.vert_slider)

    def update(self, events):
        mouse_collide = self.collide()
        if mouse_collide:
            self.background_image = self.hover_image
        else:
            self.background_image = self.inactive_image

    def add_enabled_symbols(self, e):
        self.main.enabled_symbols = e

    def add_disabled_symbols(self, d):
        self.main.disabled_symbols = d

    def add_onclick(self, p):
        self.main.onclick = p

    def add_onclick_params(self, p):
        self.main.onclick_params = p

    def add_onchange(self, p):
        self.main.onchange = p

    def add_onchange_params(self, p):
        self.main.onchange_params = p

    def add_onsubmit(self, p):
        self.main.onsubmit = p

    def add_onsubmit_params(self, p):
        self.main.onsubmit_params = p

    def add_color_text(self, p):
        self.main.color_text = p

    def get_text(self):
        return(self.main.text)

    def set_text(self, text):
        self.main.text = text