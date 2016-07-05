/* @pjs font="Dimitri.ttf"; */
int state = 0;
int substate = 0;
int swidth = 600;
int sheight = 400;
int dim = 20;
PFont font;
int introFC;
int outroFC;

ArrayList boxes = new ArrayList();
Player player;
Border outer, inner;

// colors
color white = #FFFFFF;
color red = #CC0000;
color blue = #000078;
color green = #46C846;
color orange = #FF8040;
color purple = #8B008B;

void setup() {
    font = loadFont("Dimitri.ttf", 20);
    textFont(font);
    size(swidth, sheight);
    frameRate(30);
}

// main loop function
void draw() {
    background(0);
    if (state == 0) { // menu
        fill(230);
        textFont(font, 70);
        text("Pushr", width * 0.33, height * 0.45);
        textFont(font, 20);
        text("Press Enter to play", width * 0.33, height * 0.7);
    } else if (state == 1) {
        if (substate < 2) showIntro("Replacement", 0.23, 0.45);
        else if (substate == 2) {
            Box b = new Box(12, 7);
            boxes.add(b);
            player = new Player(15, 7);
            outer = new Border(10, 5, 8, 5, white);
            inner = new Border(15, 7, 1, 1, red);
            substate += 1;
        } else if (substate == 3) {
            display();
            if (boxes.get(0).getPos() == 15+7*26) {
                inner = new Border(15, 7, 1, 1, green);
                boxes.get(0).c = green;
                outroFC = frameCount;
                substate += 1;
            }
        } else if (substate == 4) {
            display();
            if (frameCount >= outroFC + 30) {
                state += 1;
                substate = 0;
            }
        }
    } else if (state == 2) {
        if (substate < 2) showIntro("Pedantic", 0.33, 0.45);
        else if (substate == 2) {
            boxes.clear();
            //int[] lvl1 = {167,  168,  169,  193,  195,  219,  220,  221};
            int[] lvl = {13, 6, 14, 6, 15, 6, 13, 7, 15, 7, 13, 8, 14, 8, 15, 8};
            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1]);
                boxes.add(b);
            }
            player = new Player(14, 7);
            outer = new Border(2, 2, 26, 16, white);
            inner = new Border(13, 6, 3, 3, red);
            substate += 1;
        } else if (substate == 3) {
            display();
            boolean finished = true;
            for (int i = 0; i < boxes.length; i++) {
                if (!boxInTarget(boxes.get(i))) {
                    finished = false;
                    break;
                }
            }
            if (!boxInTarget(player) && finished) {
                inner = new Border(13, 6, 3, 3, green);
                for (int i = 0; i < boxes.length; i++) boxes.get(0).c = green;
                outroFC = frameCount;
                substate += 1;
            }
        } else if (substate == 4) {
            display();
            if (frameCount >= outroFC + 30) {
                state += 1;
                substate = 0;
            }
        }
    } else if (state == 3) {
        println("Level 3 to follow...");
    } else if (state == 4) {
        display();
        if (frameCount >= outroFC + 30) {
            state += 1;
            substate = 0;
        }
    } else if (state == 3) {
        println("to be implemented");
    }
}

boolean boxInTarget(Box b) {
    if (b.x >= inner.x && b.x < (inner.x + inner.w) && b.y >= inner.y && b.y < (inner.y + inner.h)) return true;
    else return false;
}

/* display boxes, player and borders */
void display() {
    outer.display();
    inner.display();
    for (int i = 0; i < boxes.size(); i++) {
        boxes.get(i).display();
    }
    player.display();
}

void showIntro(String s, float i, float j) {
    if (substate == 0) {
        introFC = frameCount;
        substate += 1;
    }
    int c = 230;
    if (frameCount-introFC <= 30) c = min((frameCount-introFC)*10, 230);
    if (frameCount-introFC >= 90) c = max(230 - (frameCount-introFC-90)*10, 0);
    fill(c);
    textFont(font, 50);
    text(s, width * i, height * j);
    if (frameCount >= introFC + 4*30) substate += 1;
}

void keyPressed() {
    if (state == 0 && keyCode == ENTER) {
        state = 1;
    }
    else {
        if (substate == 3 && key == CODED) {
            if (keyCode == UP) { player.move(0, -1); }
            else if (keyCode == DOWN) { player.move(0, 1); }
            else if (keyCode == LEFT) { player.move(-1, 0); }
            else if (keyCode == RIGHT) { player.move(1, 0); }
        }
    }
}

boolean boxThere(int x, int y) {
    for (int i = 0; i < boxes.size(); i++) {
        Box b = boxes.get(i);
        if (b.x == x && b.y == y) {
            return true;
        }
    }
    return false;
}

boolean moveBoxes(int x, int y, int xdiff, int ydiff) {
    if (boxThere(x + xdiff, y + ydiff)) {
        if (!boxThere(x + 2 * xdiff, y + 2 * ydiff)) {
            for (int i = 0; i < boxes.size(); i++) {
                if (boxes.get(i).x == x + xdiff && boxes.get(i).y + ydiff) {
                    boxes.get(i).move(xdiff, ydiff);
                    break;
                }
            }
            return true;
            } else {
                return false;
            }
        }
    return true;
}

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

    int getPos() {
        return x + y * 26;
    }
}

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
