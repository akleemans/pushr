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
boolean debug = false;

ArrayList boxes = new ArrayList();
Player player;
Border outer, inner;

color white = #FFFFFF;
color red = #CC0000;
color blue = #1874CD; //#000078;
color green = #46C846;
color orange = #FF8040;
color purple = #8B008B;
color black = #000000;
color gray = #606060;

/* Setup before game starts. */
void setup() {
    font = loadFont("Dimitri.ttf", 20);
    textFont(font);
    debugFont = createFont("Arial", 8);
    size(swidth, sheight);
    frameRate(30);
}

/* Main Game Loop. */
void draw() {
    background(black);
    if (level == 0) { // menu
        fill(230);
        textFont(font, 70);
        text("Pushr", width * 0.33, height * 0.45);
        textFont(font, 20);
        text("Press Enter to play", width * 0.33, height * 0.7);
    } else if (level == 101) {
        if (state < 2) showIntro("Substitute", 0.28, 0.45);
        else if (state == 2) {
            Box b = new Box(12, 7);
            boxes.add(b);
            player = new Player(15, 7);
            outer = new Border(10, 5, 8, 5, white);
            inner = new Border(15, 7, 1, 1, red);
            state += 1;
        } else if (state >= 3)  checkProgress();
    } else if (level == 102) {
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
        } else if (state >= 3) checkProgress();
    } else if (level == 1) {
        if (state < 2) showIntro("Escape", 0.35, 0.45);
        else if (state == 2) {
            boxes.clear();
            int[] lvl = {9,4,9,5,10,5,10,4,11,4,11,5,12,4,13,4,13,5,14,5,14,4,15,4,16,4,16,
                5,17,5,17,4,18,4,19,4,19,5,20,5,20,4,17,6,18,6,19,6,20,6,20,7,17,7,16,7,15,
                6,14,7,13,7,12,7,13,8,11,7,10,7,9,7,9,6,11,6,9,8,11,8,10,9,11,9,12,9,14,9,
                18,8,19,8,20,8,17,8,17,9,20,9,19,10,20,10,18,11,17,11,17,10,16,12,17,13,18,
                13,19,14,20,14,20,15,19,15,18,15,17,15,16,14,16,15,15,15,14,15,13,15,20,12,
                20,11,20,13,9,10,10,10,9,11,11,11,11,12,10,12,9,12,9,13,9,15,9,14,10,15,10,
                13,12,13,13,13,14,13,15,13,13,11,13,12,12,10,13,10,14,10,15,10,16,10,12,12,15,9};
            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1]);
                boxes.add(b);
            }
            player = new Player(15, 8);
            outer = new Border(2, 2, 26, 16, white);
            inner = new Border(8, 3, 12, 12, red);
            state += 1;
        } else if (state >= 3) checkProgress();
    } else if (level == 4) {
        println("to be implemented");
    }
}

/* Check if player finished level. */
void checkProgress() {
    display();

    // check if finished
    if (state == 3) {
        boolean finished = true;
        for (int i = 0; i < boxes.size(); i++) {
            if (!boxInTarget(boxes.get(i)) && boxes.get(i).c == blue) {
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
    if (debug) {
        fill(255);
        textFont(debugFont, 8);
        for (int i = 0; i < 30; i++) {
            for (int j = 0; j < 20; j++) {
                text(i + "/" + j, i*dim+4, j*dim+dim/2);
            }
        }
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
    if (frameCount-introFC >= 60) c = max(230 - (frameCount-introFC-60)*10, 0);
    fill(c);
    textFont(font, 50);
    text(s, width * i, height * j);
    if (frameCount >= introFC + 3*30) state += 1;
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
            if (boxes.get(i).c == black) boxes.get(i).c = gray;
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
        if (c == black) return;
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
