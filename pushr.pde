/* @pjs font="Dimitri.ttf"; */
int level = 0;
int state = 0;
/*  0: initialized
    1: intro text
    2: loading level
    3: gameplay
    4: finished  */
int swidth = 600;
int sheight = 400;
int dim = 20;
PFont font;
int introFC;
int outroFC;
boolean debug = true;

ArrayList boxes = new ArrayList();
Player player;
Border outer, inner;

color white = #FFFFFF;
color red = #CC0000;
color blue = #000078;
color green = #46C846;
color orange = #FF8040;
color purple = #8B008B;

/* Setup before game starts. */
void setup() {
    font = loadFont("Dimitri.ttf", 20);
    textFont(font);
    size(swidth, sheight);
    frameRate(30);
}

/* Main Game Loop. */
void draw() {
    background(0);
    if (level == 0) { // menu
        fill(230);
        textFont(font, 70);
        text("Pushr", width * 0.33, height * 0.45);
        textFont(font, 20);
        text("Press Enter to play", width * 0.33, height * 0.7);
    } else if (level == 1) {
        if (state < 2) showIntro("Substitute", 0.28, 0.45);
        else if (state == 2) {
            Box b = new Box(12, 7);
            boxes.add(b);
            player = new Player(15, 7);
            outer = new Border(10, 5, 8, 5, white);
            inner = new Border(15, 7, 1, 1, red);
            state += 1;
        } else if (state >= 3) {
            checkProgress();
        }
    } else if (level == 2) {
        if (state < 2) showIntro("Pedantic", 0.33, 0.45);
        else if (state == 2) {
            boxes.clear();
            int[] lvl = {13, 6, 15, 6, 13, 8, 15, 8, 14, 8, 14, 9, 12, 7, 16, 7, 14, 5};
            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1]);
                boxes.add(b);
            }
            player = new Player(14, 7);
            outer = new Border(2, 2, 26, 16, white);
            inner = new Border(13, 6, 3, 3, red);
            state += 1;
        } else if (state >= 3) {
            checkProgress();
        }
    } else if (level == 3) {
        println("to be implemented");
    } else if (level == 4) {
        println("to be implemented");
    } else if (level == 5) {
        println("to be implemented");
    }
}

void checkProgress() {
    display();

    // check if finished
    if (state == 3) {
        boolean finished = true;
        for (int i = 0; i < boxes.size(); i++) {
            if (!boxInTarget(boxes.get(i))) {
                finished = false;
                break;
            }
        }
        if (!boxInTarget(player) && finished) {
            inner.c = green;
            for (int i = 0; i < boxes.size(); i++) boxes.get(i).c = green;
            outroFC = frameCount;
            state += 1;
        }
    }
    else if (state == 4 && frameCount >= outroFC + 30) {
        level += 1;
        state = 0;
    }
}

/* Check if all boxes are in target zone. */
boolean boxInTarget(Entity b) {
    if ((b.x >= inner.x) && (b.x < (inner.x + inner.w)) && (b.y >= inner.y) && (b.y < (inner.y + inner.h))) {
        return true;
    }
    else { return false; }
}

/* Display boxes, player and borders. */
void display() {
    outer.display();
    inner.display();
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).display();
    }
    player.display();
}

/* Show a fading intro text before a level starts. */
void showIntro(String s, float i, float j) {
    if (state == 0) {
        introFC = frameCount;
        state += 1;
    }
    int c = 230;
    if (frameCount-introFC <= 30) c = min((frameCount-introFC)*10, 230);
    if (frameCount-introFC >= 90) c = max(230 - (frameCount-introFC-90)*10, 0);
    fill(c);
    textFont(font, 50);
    text(s, width * i, height * j);
    if (frameCount >= introFC + 4*30) state += 1;
}

/* Check if key has been pressed. */
void keyPressed() {
    if (level == 0 && keyCode == ENTER) {
        level = 1;
    }
    else {
        if (state == 3 && key == CODED) {
            if (keyCode == UP) { player.move(0, -1); }
            else if (keyCode == DOWN) { player.move(0, 1); }
            else if (keyCode == LEFT) { player.move(-1, 0); }
            else if (keyCode == RIGHT) { player.move(1, 0); }
        }
    }
}

/* Check if a box exists at coordinates x, y. */
boolean boxThere(int x, int y) {
    for (int i = 0; i < boxes.size(); i++) {
        if (boxes.get(i).x == x && boxes.get(i).y == y) {
            return true;
        }
    }
    return false;
}

/* Move boxes. TODO: needs fixing.*/
boolean moveBoxes(int x, int y, int xdiff, int ydiff) {
    // check if one box in front
    if (boxThere(x + xdiff, y + ydiff)) {
        // another box after that?
        if (!boxThere(x + xdiff*2, y + ydiff*2)) {
            // if no, search for adjacent box and move it
            for (int i = 0; i < boxes.size(); i++) {
                if (boxes.get(i).x == (x + xdiff) && boxes.get(i).y == (y + ydiff)) {
                    boxes.get(i).move(xdiff, ydiff);
                    break;
                }
            }
            return true;
        } else { // 2 boxes in way
            return false;
        }
    }
    return true;
}

/* A basic entity class with constructor and move(). */
class Entity {
    int x, y, w, h;
    color c;

    Entity(int _x, int _y, int _w, int _h, color _c) {
        x = _x; y = _y;
        w = _w; h = _h;
        c = _c
    }

    void move(int xdiff, int ydiff) {
        x += xdiff;
        y += ydiff;
    }
}

/* Border class. */
class Border extends Entity {
    Border(int _x, int _y, int _w, int _h, color _c) {
        super(_x, _y, _w, _h, _c);
    }

    void display() {
        fill(0, 0, 0);
        stroke(c);
        strokeWeight(3);
        rect(x*dim, y*dim, w*dim, h*dim);
    }
}

/* Box class. */
class Box extends Entity {
    Box(int _x, int _y) {
        super(_x, _y, 1, 1, blue);
    }

    void display() {
        fill(c);
        stroke(255);
        strokeWeight(1);
        rect(x*dim, y*dim, w*dim, h*dim);
    }
}

/* Player class. */
class Player extends Entity {
    Player(int _x, int _y) {
        super(_x, _y, 1, 1, orange);
    }

    void move(int xdiff, int ydiff) {
        if (moveBoxes(x, y, xdiff, ydiff)) {
            x += xdiff
            y += ydiff;
        }
    }

    void display() {
        fill(c);
        stroke(255);
        strokeWeight(1);
        rect(x*dim, y*dim, w*dim, h*dim);
        rect(x*dim + 2, y*dim + 2, w*dim - 4, h*dim - 4);
    }
}
