/* @pjs font="Dimitri.ttf"; */
int state = 0;
int substate = 0;
int width = 600;
int height = 400;
int dim = 20;
int debug = false;
PFont font;
int introFC;

ArrayList boxes = new ArrayList();
Player player;
Border outer, inner;

// colors
color white = #FFFFFF;
color red = #CC0000;

void setup() {
  font = loadFont("Dimitri.ttf", 20);
  textFont(font);
  size(width, height);
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
    } else if (state == 1) { // level 1
        if (substate < 2) showIntro("Replacement", 0.23, 0.45); // 0 - begin intro, 1 - show intro
        else if (substate == 2) { // 2 - init
            int[] lvl1 = {167,  168,  169,  193,  195,  219,  220,  221};
            for (int i = 0; i < lvl1.length; i++) {
                int p = lvl1[i];
                Box b = new Box(p, dim, dim);
                boxes.add(b);
            }
            player = new Player(194, dim, dim);
            outer = new Border(2 * dim, 2 * dim, width - 4 * dim, height - 4 * dim, white);
            inner = new Border(13 * dim, 8 * dim, 3 * dim, 3 * dim, red);
            println("Finished initializing...");
            substate += 1;
        } else { // 2 - level
            println("Displaying borders & player.")
            outer.display();
            inner.display();
            for (int i = 0; i < boxes.size(); i++) {
                boxes.get(i).display();
            }
            player.display();
            // TODO check if level finished
        }
    } else if (state == 2) {
        println("Level 2 to follow...");
    }
}

void showIntro(String s, float i, float j) {
    if (substate == 0) {
        introFC = frameCount;
        substate += 1;
    }
    textFont(font, 50);
    text(s, width * i, height * j);
    if (frameCount >= introFC + 3*30) substate += 1;
}

void keyPressed() {
    if (state == 0 && keyCode == ENTER) {
        state = 1;
    }
    else {
        if (key == CODED) {
            if (keyCode == UP) { player.move(0, -1); }
            else if (keyCode == DOWN) { player.move(0, 1); }
            else if (keyCode == LEFT) { player.move(-1, 0); }
            else if (keyCode == RIGHT) { player.move(1, 0); }
        }
    }
}

int[] getPosition(int boxId) {
  int[] pos = { 2 * dim + (boxId % 26) * dim, 2 * dim + (boxId - boxId % 26) / 26 * dim };
  return pos;
}

boolean boxThere(int boxId) {
    for (int i = 0; i < boxes.size(); i++) {
        if (boxes.get(i).getPos() == boxId) {
            return true;
        }
    }
    return false;
}

boolean moveBoxes(int boxId, int xdiff, int ydiff) {
  if (boxThere(boxId + xdiff + ydiff * 26)) {
    if (!boxThere(boxId + 2 * xdiff + 2 * ydiff * 26)) {
      // get correct box
      for (int i = 0; i < boxes.size(); i++) {
        if (boxes.get(i).getPos() == boxId + xdiff + ydiff * 26) {
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

class Border {
  int xpos, ypos, w, h, color;

  Border(int ixpos, int iypos, int iw, int ih, color ic) {
    xpos = ixpos;
    ypos = iypos;
    w = iw;
    h = ih;
    color = ic;
  }

  void display() {
    fill(0, 0, 0);
    stroke(color);
    strokeWeight(3);
    rect(xpos, ypos, w, h);
  }
}

class Box {
  int boxId, w, h;

  Box(int iboxId, int iw, int ih) {
    boxId = iboxId;
    w = iw;
    h = ih;
  }

  void move(int xdiff, int ydiff) {
    boxId += xdiff + ydiff * 26;
  }

  void display() {
    fill(0, 0, 80);
    h
    stroke(255);
    strokeWeight(1);
    int[] p = getPosition(boxId);
    rect(p[0], p[1], w, h);
  }

  int getPos() {
    return boxId;
  }
}

class Player {
  int boxId, w, h;
  Player(int iboxId, int iw, int ih) {
    boxId = iboxId;
    w = iw;
    h = ih;
  }

  void move(int xdiff, int ydiff) {
    if (moveBoxes(boxId, xdiff, ydiff)) {
      boxId += xdiff + ydiff * 26;
    }
  }

  void display() {
    fill(255, 48, 48);
    stroke(255);
    strokeWeight(1);
    int[] p = getPosition(boxId);
    rect(p[0], p[1], w, h);
    rect(p[0] + 2, p[1] + 2, w - 4, h - 4);
  }
}
