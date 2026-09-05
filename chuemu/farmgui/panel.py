from farmgui.component import *
import pygame
pygame.init()

class Panel(Component):
    def __init__(self, rect, background_color=(50, 50, 50), is_main=0, **kwargs):
        Component.__init__(self, rect, **kwargs)
        self.background_image = kwargs.get("background_image")
        if kwargs.get("background_image") == None:
            self.background_image = pygame.Surface((self.rect.w, self.rect.h), pygame.SRCALPHA)
            self.background_image.fill(background_color)
        self.buttons = []
        self.is_main = is_main
        self.first_upd = 1
        self.is_panel = 1

    def update_component(self, events):
        if self.is_main and self.first_upd:#если главная панель запускается в первый раз, то она определяет абсолютную позицию у всех дочерних компонентов
            self.first_upd = 0
            self.set_absolute_pos()
        self.update(events)
        mousedown = pygame.mouse.get_pressed()[0]
        mouse_collide = self.collide()
        if mouse_collide:
            if mousedown:
                if self.input_manager.mousetag_object[0] == None:
                    press_button = 0
                    for b in self.buttons:
                        m_c = b.collide()
                        press_button = m_c
                        if m_c:
                            break
                    if not press_button:
                        self.input_manager.mousetag_object[0] = self
            else:
                if self.input_manager.mousetag_object[0] == self:
                    self.input_manager.mousetag_object[0] = None
        else:
            if not mousedown:
                if self.input_manager.mousetag_object[0] == self:
                    self.input_manager.mousetag_object[0] = None
        for b in self.buttons:
            b.update_component(events)

    def draw(self, screen):
        self.image.blit(self.background_image, (0, 0))
        for b in self.buttons:
            b.draw(self.image)
        screen.blit(self.image, self.rect)

    def add(self, b):
        self.buttons.append(b)
        b.parent = self

    def remove(self, b):
        self.buttons.remove(b)

    def get_mousepos(self):
        mousepos = pygame.mouse.get_pos()
        if self.is_main == 0:
            mpos = (mousepos[0] - self.parent.absolute_pos[0], mousepos[1] - self.parent.absolute_pos[1])#позиция мыши относительно родительского компонента
            return(mpos)
        else:
            return(mousepos)

    def get_components(self):
        return(self.buttons)

    def get_component_count(self):
        return(len(self.buttons))

    def get_screen(self):
        return(self.image)