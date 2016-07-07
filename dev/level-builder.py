import pygame

pygame.init()
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
BLUE = (0, 0, 120)
GREEN = (0, 255, 0)
RED = (255, 0, 0)

w, h = 26, 16
size = (w*20, h*20)
screen = pygame.display.set_mode(size)
pygame.display.set_caption("Pushr Level builder")
done = False
clock = pygame.time.Clock()
boxes = []

while not done:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            done = True
        elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
            pos = pygame.mouse.get_pos()
            x, y = (pos[0] - pos[0]%20)/20, (pos[1] - pos[1]%20)/20
            el = [x, y]
            if el in boxes: boxes.remove(el)
            else: boxes.append(el)
        elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 3:
            print ','.join([str(box[0]+2) + ',' + str(box[1]+2) for box in boxes])

    screen.fill(WHITE)
    # draw lines
    for i in range(w):
        pygame.draw.line(screen, BLUE, [i*20, 0], [i*20, h*20])
    for i in range(h):
        pygame.draw.line(screen, BLUE, [0, i*20], [w*20, i*20])

    # draw boxes
    for box in boxes:
        pygame.draw.rect(screen, BLUE, [box[0]*20, box[1]*20, 20, 20], 0)

    pygame.display.flip()
    clock.tick(60)

pygame.quit()
