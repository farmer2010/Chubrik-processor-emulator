from farmgui.button import *
from farmgui.text_box import *
from farmgui.text_label import *
from farmgui.slider import *
from farmgui.radiobutton import *
from farmgui.radiobutton_group import *
from farmgui.panel import *
from farmgui.text_field import *
from farmgui.text_field_main import *
from farmgui.number_box import *
#
from farmgui.input_manager import *
from farmgui.utils import *

class ButtonManager():
    def __init__(self, background_color=(50, 50, 50), background_image=None):
        self.input_manager = input_manager
        self.screenpanel = Panel((0, 0, pygame.display.Info().current_w, pygame.display.Info().current_h), background_color=background_color, background_image=background_image, is_main=1)

    def update(self, screen, events):
        self.screenpanel.update_component(events)
        self.screenpanel.draw(screen)
        self.input_manager.update(events)

    def add(self, b):
        self.screenpanel.add(b)

    def remove(self, b):
        self.screenpanel.remove(b)

    def get_component(self, index):
        return(self.screenpanel.buttons[index])

    def get_component_count(self):
        return(len(self.screenpanel.buttons))