/* @pjs font="assets/Dimitri.ttf"; */
int level = 0;
int highest_level = 0;
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
ArrayList bg = new ArrayList();
Player player;
Player player2;
Border outer, inner;
PImage restart, forward, back;
PImage[] controls;
boolean forward_available = true, back_available = true;
boolean gravity = false;

color white = #FFFFFF;
color red = #CC0000;
color blue = #1874CD; //#000078;
color green = #46C846;
color orange = #FF8040;
color orange2 = #FFBB99;
color purple = #8B008B;
color black = #000000;
color gray = #222222; //#111111 #606060;
color ice = #9CCFFC; // #D4F0FF; //#B5EBF5;
color coil_ice = #9CCFFD; // blocking ice, for mortal coil level
color passage = #8B008B;

/* Setup before game starts. */
void setup() {
    // load fonts and images
    font = loadFont("assets/Dimitri.ttf", 20);
    textFont(font);
    debugFont = createFont("Arial", 8);

    // image credit to https://design.google.com/icons/
    restart = loadImage("assets/restart.png");
    forward = loadImage("assets/forward.png");
    back = loadImage("assets/back.png");
    controls = {back, restart, forward};

    size(swidth, sheight);
    frameRate(30);
}

/* Main Game Loop. */
void draw() {
    background(black);
    // for debugging
    level = 11;
    if (level == 0) { // menu
        fill(230);
        textFont(font, 70);
        text("Pushr", width * 0.33, height * 0.45);
        textFont(font, 20);
        text("Press Enter to play", width * 0.33, height * 0.7);
    } else if (level == 1) {
        if (state < 2) showIntro("Substitute", 0.28, 0.45);
        else if (state == 2) {
            clearLevel();
            Box b = new Box(13, 8);
            boxes.add(b);
            player = new Player(16, 8);
            outer = new Border(11, 6, 8, 5, white);
            inner = new Border(16, 8, 1, 1, red);
            state += 1;
        } else if (state >= 3)  checkProgress();
    } else if (level == 2) { // 2
        if (state < 2) showIntro("Pedantic", 0.33, 0.45);
        else if (state == 2) {
            clearLevel();
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
    } else if (level == 3) {
        if (state < 2) showIntro("Escape", 0.35, 0.45);
        else if (state == 2) {
            clearLevel();
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
            inner = new Border(9, 4, 12, 12, red);
            state += 1;
        } else if (state >= 3) checkProgress();
    } else if (level == 4) {
        if (state < 2) showIntro("Hidden", 0.37, 0.45);
        else if (state == 2) {
            clearLevel();
            int[] lvl = {12, 3, 11, 3, 10, 3, 9, 3, 8, 3, 8, 4, 9, 4, 10, 4, 11,
                4, 12, 4, 9, 5, 8, 5, 9, 6, 8, 6, 9, 7, 8, 7, 9, 8, 8, 8, 9, 11,
                8, 11, 9, 12, 8, 12, 9, 13, 8, 13, 9, 14, 8, 14, 8, 16, 8, 15,
                9, 15, 9, 16, 10, 15, 10, 16, 11, 15, 11, 16, 12, 15, 12, 16,
                17, 14, 17, 15, 18, 14, 18, 15, 19, 14, 19, 15, 20, 15, 20, 14,
                21, 14, 21, 15, 21, 13, 20, 13, 21, 12, 20, 12, 21, 11, 20, 11,
                21, 10, 20, 10, 21, 9, 20, 9, 21, 8, 20, 8, 21, 7, 20, 7, 21,
                6, 20, 6, 21, 5, 20, 5, 21, 4, 21, 3, 20, 3, 20, 4, 19, 4, 19,
                3, 18, 3, 18, 4, 17, 4, 17, 3};
            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1]);
                b.c = black;
                boxes.add(b);
            }
            int[] lvl = {6, 8, 6, 11, 23, 8, 23, 11};
            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1]);
                boxes.add(b);
            }
            player = new Player(15, 6);
            outer = new Border(2, 2, 26, 16, white);
            inner = new Border(15, 10, 2, 2, red);
            state += 1;
        } else if (state >= 3) checkProgress();
    } else if (level == 5) {
        if (state < 2) showIntro("Slippery", 0.33, 0.45);
        else if (state == 2) {
            clearLevel();
            Rectangle e = new Rectangle(2, 2, 26, 10, ice); // ice
            bg.add(e);
            int[] lvl = {4,12,5,12,9,12,10,12,11,13,11,12,12,13,12,12,13,13,13,
                12,14,12,15,12,16,13,16,12,18,12,17,12,21,12,20,12,22,13,23,12,
                22,12,24,13,25,14,25,13,24,12,25,12,26,13,26,12,27,12,27,13};
            for (int i = 0; i < lvl.length; i+=2) {
                Rectangle e = new Rectangle(lvl[i], lvl[i+1], 1, 1, ice);
                bg.add(e);
            }

            int[] lvl = {2,2,3,2,4,2,5,2,5,3,12,3,13,3,13,2,14,2,15,2,16,2,23,2,
                24,3,27,4,27,5,27,6,26,5,19,2,19,6,15,5,14,7,13,6,9,7,8,8,7,9,8,
                9,9,10,10,10,11,11,12,10,15,10,16,9,4,9,3,9,2,10,2,11,2,13,3,11,
                2,12}; // fixed
            for (int i = 0; i < lvl.length; i+=2) {
                Rectangle e = new Rectangle(lvl[i], lvl[i+1], 1, 1, gray);
                boxes.add(e);
            }

            int[] lvl = {6,5,19,7,18,7,26,7}; // boxes
            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1]);
                boxes.add(b);
            }
            player = new Player(11, 16);
            outer = new Border(2, 2, 26, 16, white);
            inner = new Border(16, 15, 2, 2, red);
            state += 1;
        } else if (state >= 3) checkProgress();
    } else if (level == 6) {
        if (state < 2) showIntro("Corridor", 0.32, 0.45);
        else if (state == 2) {
            clearLevel();
            // fixed boxes
            int[] lvl = {13,11,13,12,14,12,15,12,16,12,16,11,16,8,16,7,15,7,14,7,13,7,13,8};
            for (int i = 0; i < lvl.length; i+=2) {
                Box e = new Box(lvl[i], lvl[i+1], gray);
                boxes.add(e);
            }
            // movable boxes
            int[] lvl = {5,8,5,9,5,10,5,11};
            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1]);
                boxes.add(b);
            }
            // ice
            int[] lvl = {12,9,12,10,13,9,13,10,14,9,14,10,15,9,15,10,16,9,16,10,17,9,17,10};
            for (int i = 0; i < lvl.length; i+=2) {
                Rectangle e = new Rectangle(lvl[i], lvl[i+1], 1, 1, ice);
                bg.add(e);
            }

            player = new Player(9,10);
            outer = new Border(2, 2, 26, 16, white);
            inner = new Border(14,10, 2, 2, red);
            state += 1;
        } else if (state >= 3) checkProgress();
    } else if (level == 7) {
        if (state < 2) showIntro("Tetris", 0.35, 0.45);
        else if (state == 2) {
            clearLevel();
            // movable boxes
            int[] lvl = {15,6,16,6,16,7,16,8,16,10,15,10,15,9,14,9,14,7,14,8,13,8,12,8};
            for (int i = 0; i < lvl.length; i+=2) {
                if (i < 8) c = blue;
                else if (i >= 8 && i < 16) c = purple;
                else c = green;
                Box b = new Box(lvl[i], lvl[i+1], c);
                boxes.add(b);
            }
            player = new Player(14,11);
            outer = new Border(12,5, 6, 10, white);
            inner = new Border(12,13, 6, 2, red);
            state += 1;
        } else if (state >= 3) checkProgress();
    } else if (level == 8) {
      if (state < 2) showIntro("Leaving Traces", 0.21, 0.45);
      else if (state == 2) {
          clearLevel();
          // special ice, only once walkable
          for (int i = 6; i <= 23; i += 1) {
              for (int j = 5; j <= 15; j += 1) {
                  Rectangle e = new Rectangle(i, j, 1, 1, coil_ice);
                  bg.add(e);
              }
          }

          int[] lvl = {6,5, 8,5, 9,5, 10,5, 12,5, 13,5, 14,5, 15,5, 16,5, 19,5,
              22,5, 23,5, 23,6, 23,7, 6,6, 6,9, 6,10, 6,13, 6,14, 6,15,
              7,15, 10,15, 11,15, 12,15, 13,15, 14,15, 16,15, 17,15, 18,15, 19,15, 20,15,
              22,15, 23,15, 23,14, 23,13, 23,12, 23,11, 23,10, 23,9, 23,8}; // fixed
          for (int i = 0; i < lvl.length; i+=2) {
              Box e = new Box(lvl[i], lvl[i+1], gray);
              boxes.add(e);
          }

          int[] lvl = {14,10}; // boxes
          for (int i = 0; i < lvl.length; i+=2) {
              Box b = new Box(lvl[i], lvl[i+1]);
              boxes.add(b);
          }
          player = new Player(14, 3);
          outer = new Border(2, 2, 26, 16, white);
          inner = new Border(14, 9, 1, 1, red);
          state += 1;
      } else if (state >= 3) checkProgress();
    } else if (level == 9) {
        if (state < 2) showIntro("Entangled", 0.32, 0.45);
        else if (state == 2) {
            clearLevel();
            // room divider
            for (int i = 14; i <= 15; i += 1) {
                for (int j = 4; j <= 15; j += 1) {
                    Box e = new Box(i, j, gray);
                    boxes.add(e);
                }
            }

            int[] lvl = {8,8, 7,9, 6,10, 5,11, 22,8, 23,9, 24,10, 25,11}; // boxes
            //int[] lvl = {7,8, 8,8, 7,9, 7,10, 6,10, 22,8, 23,8, 23,9, 23,10, 24,10};
            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1]);
                boxes.add(b);
            }
            player = new Player(3, 5);
            player2 = new Player(17, 5);

            outer = new Border(2, 4, 26, 12, white);
            inner = new Border(13, 8, 4, 4, red);
            state += 1;
        } else if (state >= 3) checkProgress();
    } else if (level == 10) {
        if (state < 2) showIntro("Gravity", 0.35, 0.45);
        else if (state == 2) {
            clearLevel();

            int[] lvl = {
                24,7,24,8,23,9,23,10,4,5,6,2,5,2,25,14,6,4,25,12,25,11,26,11,23,
                3,25,4,26,3,18,2,23,5,25,6,24,5,24,6,26,16,8,5,9,5,10,5,12,5,13,
                5,14,5,15,5,16,5,17,5,18,5,19,5,12,2,5,7,7,7,8,7,9,7,12,7,13,7,
                18,7,17,7,16,7,15,7,20,7,21,7,3,9,10,9,11,9,14,9,12,9,13,9,15,9,
                17,9,19,9,18,9,16,9,2,16,9,12,12,12,11,12,10,12,20,12,15,12,19,
                12,16,12,13,12,14,12,2,17,21,15,20,15,19,15,17,15,16,15,15,15,14,
                15,3,14,6,15,9,15,10,15,11,15,12,17,13,15,11,17,10,17,9,17,8,17,
                6,17,5,17,7,17,4,17,3,17,3,15,22,17,21,17,20,17,19,17,18,17,17,
                17,16,17,15,17,14,17,13,17,23,17,17,12,18,12,18,15,22,15,24,17,
                25,16,5,15,5,16,5,14,4,13,3,11,6,16,9,16,10,16,11,16,6,11,5,11,
                3,7,2,6,2,7,2,10,17,10,13,10,11,10,16,10,25,9,27,8,27,6,20,2,21,
                2,24,14,26,13,7,15,4,15,4,16,2,12,23,12,7,16 }; // fixed

            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1], gray);
                boxes.add(b);
            }

            int[] lvl = {14,2, 14,3, 14,1, 18,4}; // boxes
            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1]);
                boxes.add(b);
            }

            player = new Player(15, 3);

            outer = new Border(2, 2, 26, 16, white);
            inner = new Border(7, 15, 7, 3, red);
            state += 1;
            gravity = true;
        } else if (state >= 3) checkProgress();
    } else if (level == 11) {
        if (state < 2) showIntro("One-Way", 0.35, 0.45);
        else if (state == 2) {
            gravity = false;
            clearLevel();
            int[] lvl = { 9,9, 12,4, 18,4, 20,7, 20,12 }; // one-way entries 15,15
            for (int i = 0; i < lvl.length; i+=2) {
                Rectangle e = new Rectangle(lvl[i], lvl[i+1], 1, 1, passage);
                bg.add(e);
            }

            int[] lvl = { 9,4,10,4,11,4,9,5,10,5,11,5,10,6,9,6,10,7,9,7,9,8,9,10,
                10,10,9,11,9,12,10,12,9,13,12,14,9,14,9,15,10,15,11,15,12,15,13,
                15,14,15,16,15,17,15,18,15,18,14,18,12,19,15,20,15,20,14,20,13,
                20,11,18,10,15,10,14,10,13,10,12,10,13,11,14,9,14,8,14,7,15,6,16,
                6,13,5,13,4,14,4,15,4,16,4,17,4,19,4,20,4,20,5,20,6,20,8,20,9,20,
                10,11,14,17,10,16,10,15,11,15,7,16,14,11,7,17,7,16,5,16,12,19,10,
                15,15 }; // fixed

            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1], gray);
                boxes.add(b);
            }

            int[] lvl = {11,8, 12,7, 18,8, 18,13}; // boxes
            for (int i = 0; i < lvl.length; i+=2) {
                Box b = new Box(lvl[i], lvl[i+1]);
                boxes.add(b);
            }

            player = new Player(6, 9);

            outer = new Border(2, 2, 26, 16, white);
            inner = new Border(13, 8, 3, 2, red);
            state += 1;
            gravity = true;
        } else if (state >= 3) checkProgress();
    } else if (level == 12) {
        println('wip');
    } else if (level == 13) {
        println('wip');
    } else if (level == 14) {
        println('wip');
    } else if (level == 15) {
        println('wip');
    } else if (level == 16) {
        println('wip');
    } else if (level == 17) {
        println('wip');
    } else if (level == 18) {
        println('wip');
    } else if (level == 19) {
        println('wip');
    } else if (level == 20) {
        println('wip');
    } else if (level == 21) {
        println('wip');
    } else if (level == 22) {
        println('wip');
    } else if (level == 23) {
        println('wip');
    } else if (level == 24) {
        println('wip');
    } else if (level == 25) {
        println('wip');
    }
}

/* Clears the current level and deletes all entities. */
void clearLevel() {
    boxes.clear();
    bg.clear();
    player2 = null;
}

/* Check if player finished level. */
void checkProgress() {
    display();

    // check if finished
    if (state == 3) {
        boolean finished = true;
        for (int i = 0; i < boxes.size(); i++) {
            if (!boxInTarget(boxes.get(i)) &&
            ((boxes.get(i).c == blue) ||
            (boxes.get(i).c == purple) ||
            (boxes.get(i).c == green)) ) {
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
        highest_level = level;
        state = 0;
    }
}

/* Check if all boxes are in target zone. */
boolean boxInTarget(Rectangle b) {
    if ((b.x >= inner.x) && (b.x < (inner.x + inner.w)) && (b.y >= inner.y) && (b.y < (inner.y + inner.h))) {
        return true;
    }
    else { return false; }
}

/* Checks if rectangle in another. */
boolean inBorder(Rectangle a, Rectangle b) {
    //println("comparing:" + a.x + "/" + a.y + " | " + b.x + "/" + b.y);
    if ((a.x >= b.x) && (a.x < (b.x + b.w)) && (a.y >= b.y) && (a.y < (b.y + b.h))) {
        return true;
    }
    else { return false; }
}


/* Check if box on ice. */
boolean rectangleOnIce(Rectangle b) {
    for (int i = 0; i < bg.size(); i++) {
        Rectangle r = bg.get(i);
        if ((r.c == ice || r.c == coil_ice) && (b.x >= r.x) && (b.x < (r.x + r.w)) && (b.y >= r.y) && (b.y < (r.y + r.h))) {
            return true;
        }
    }
    return false;
}

/* Display boxes, player and borders. */
void display() {
    // do some automatic calculations
    if (gravity) {
        player.fall();
        for (int i = 0; i < boxes.size(); i++) boxes.get(i).fall();
    }

    outer.display();
    for (int i = 0; i < bg.size(); i++) bg.get(i).display();
    for (int i = 0; i < boxes.size(); i++) boxes.get(i).display();
    inner.display();
    player.display();
    if (player2 != null) { player2.display(); }

    // controls
    noFill();
    strokeWeight(1);
    for (int i = 0; i < controls.length; i++) {
        if (i == 0 && level == 1) {back_available = false; continue;}
        if (i == 2 && level >= highest_level) {forward_available = false; continue;}
        PImage img = controls[i];
        pushMatrix();
        translate(width/2-50+i*50, height-22);
        image(img, -img.width/2, -img.height/2);
        popMatrix();
        if (i == 0) back_available = true;
        if (i == 2) forward_available = true;
    }
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
            if (keyCode == UP) {
                player.move(0, -1);
                if (player2 != null) player2.move(0, -1);
            }
            else if (keyCode == DOWN) {
                player.move(0, 1);
                if (player2 != null) player2.move(0, 1);
            }
            else if (keyCode == LEFT) {
                player.move(-1, 0);
                if (player2 != null) player2.move(-1, 0);
            }
            else if (keyCode == RIGHT) {
                player.move(1, 0);
                if (player2 != null) player2.move(1, 0);
            }
        }
    }
}

/* Check if mouse is clicked and hit one of the buttons*/
void mouseClicked() {
    if (level >= 1 && mouseY > height-32 && mouseY < height-12) {
        if (mouseX > width/2-10 && mouseX < width/2+10) { // restart
            state = 0;
        } else if (forward_available && mouseX > width/2+40 && mouseX < width/2+60) {
            state = 0;
            level += 1;
        } else if (back_available && mouseX > width/2-60 && mouseX < width/2-40) {
            state = 0;
            level -= 1;
        }
    }
}

/* Gets box from coordinate. */
Box getBox(int x, int y) {
    for (int i = 0; i < boxes.size(); i++) {
        if (boxes.get(i).x == x && boxes.get(i).y == y) {
            return boxes.get(i);
        }
    }
}

/* Gets box from coordinate. */
Rectangle getBg(int x, int y) {
    for (int i = 0; i < bg.size(); i++) {
        if (bg.get(i).x == x && bg.get(i).y == y) {
            return bg.get(i);
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

/* Move boxes. */
boolean moveBoxes(int x, int y, int xdiff, int ydiff) {
    // check if one box in front
    if (boxThere(x + xdiff, y + ydiff)) {
        Box b = new Box(x + xdiff*2, y + ydiff*2);
        if (!inBorder(b, outer)) return false; // box may not leave border
        if (getBox(x + xdiff, y + ydiff).c == gray) return false; // gray = fixed
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

/* -------------------------- Classes -------------------------- */

/* A basic entity class with constructor and move(). */
class Rectangle {
    int x, y, w, h;
    color c;

    Rectangle(int _x, int _y, int _w, int _h, color _c) {
        x = _x; y = _y;
        w = _w; h = _h;
        c = _c
    }

    void move(int xdiff, int ydiff) {
        x += xdiff;
        y += ydiff;
    }

    void fall() {
        // outer border hardcoded to 2.
        if (c != gray && getBox(x, y+1) == null && y < 17 && !(player.x == x && player.y == y+1)) {
            y += 1;
        }
    }

    void display() {
        noStroke();
        fill(c);
        rect(x*dim, y*dim, w*dim, h*dim);
    }
}

/* Border class. */
class Border extends Rectangle {
    Border(int _x, int _y, int _w, int _h, color _c) {
        super(_x, _y, _w, _h, _c);
    }

    void display() {
        noFill();
        stroke(c);
        strokeWeight(3);
        rect(x*dim, y*dim, w*dim, h*dim);
    }
}

/* Box class. */
class Box extends Rectangle {
    Box(int _x, int _y) {
        super(_x, _y, 1, 1, blue);
    }

    Box(int _x, int _y, color _c) {
        super(_x, _y, 1, 1, _c);
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
class Player extends Rectangle {
    Player(int _x, int _y) {
        super(_x, _y, 1, 1, orange);
    }

    void move(int xdiff, int ydiff) {
        if (gravity && ydiff != 0) return;
        if (inBorder(new Box(x+xdiff, y+ydiff), outer) && moveBoxes(x, y, xdiff, ydiff)) {
            if (getBg(x, y) != null && (getBg(x, y).c == coil_ice || getBg(x, y).c == passage)) { boxes.add(new Box(x, y, gray)); }
            x += xdiff
            y += ydiff;

            // check if on ice
            while (inBorder(new Box(x+xdiff, y+ydiff), outer) && rectangleOnIce(this) && moveBoxes(x, y, xdiff, ydiff)) {
                if (getBg(x, y) != null && (getBg(x, y).c == coil_ice || getBg(x, y).c == passage)) { boxes.add(new Box(x, y, gray)); }
                x += xdiff
                y += ydiff;
            }
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
