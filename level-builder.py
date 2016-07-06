import pygame

pygame.init()
BLACK = (0, 0, 0)
WHITE = (255, 255, 255)
BLUE = (0, 0, 120)
GREEN = (0, 255, 0)
RED = (255, 0, 0)
 
size = (26*20, 16*20)
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

            # TODO check if box already exists
            boxes.append([x, y])
        elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 3:
            print ', '.join([str(box[0]+2) + ', ' + str(box[1]+2) for box in boxes])
    
    screen.fill(WHITE)
    for box in boxes: # draw boxes
        pygame.draw.rect(screen, BLUE, [box[0]*20, box[1]*20, 20, 20], 0)
    pygame.display.flip()
    clock.tick(60)
    
pygame.quit()
