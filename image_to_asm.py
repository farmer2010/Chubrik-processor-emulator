import pygame
import pyperclip
pygame.init()

name = input("Enter filename: ")
image = pygame.image.load(name)
disp = [[0 for y in range(16)]for x in range(16)]
print()

for x in range(16):
    for y in range(16):
        pixel = image.get_at((x, y))
        if (pixel[0] + pixel[1] + pixel[2]) / 3 > 220:#white
            disp[x][y] = 0
        elif pixel[0] > pixel[1] and pixel[0] > pixel[2] and pixel[0] > 170:#red
            disp[x][y] = 1
        elif pixel[2] > pixel[0] and pixel[2] > pixel[1] and pixel[2] > 170:#blue
            disp[x][y] = 2
        elif abs(pixel[0] - pixel[2]) < 40:#magenta
            disp[x][y] = 3

txt_red = "display db          0b"
txt_blue = "display_blue db     0b"
for y in range(16):
    for x in range(16):
        if x % 8 == 0 and x + y != 0 and x != 0:
            txt_red += ", 0b"
            txt_blue += ", 0b"
        if disp[x][y] == 1 or disp[x][y] == 3:
            txt_red += "1"
        else:
            txt_red += "0"
        if disp[x][y] == 2 or disp[x][y] == 3:
            txt_blue += "1"
        else:
            txt_blue += "0"
        if x == 15 and y != 15:
            txt_red += ",\n                    0b"
            txt_blue += ",\n                    0b"

txt = ""
txt += txt_red
txt += "\n\n"
txt += txt_blue
print(txt)
pyperclip.copy(txt)
pygame.quit()
