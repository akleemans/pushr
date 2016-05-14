Border outer, inner;

String state;
int lvl;
int width = 600;
int height = 400;
int dim = 20;

int debug = false;

// 26 * 16
int[] lvl1 = {167,  168,  169,  193,  195,  219,  220,  221 };
boxes = new ArrayList();

// colors
color white = #FFFFFF;
color red = #CC0000;

void setup() {
  state = "building";
  lvl = 0;
  size(width, height);
  outer = new Border(2 * dim, 2 * dim, width - 4 * dim, height - 4 * dim, white);
  inner = new Border(13 * dim, 8 * dim, 3 * dim, 3 * dim, red);
}

// main loop function
void draw() {
  background(0);
  if (state == "building") {
    buildlevel();
  } else if (state == "level") {
    outer.display();
    inner.display();
    if (debug) {
      for (int i = 0; i < 26 * 16; i++) {
        fill(200); // color the text #CCCCCC
        PFont fontArial = loadFont("arial");
        textFont(fontArial, 8);
        text(i, 2 * dim + (i % 26) * dim + 5, 2 * dim + (i - i % 26) / 26 * dim + 10);
      }
    }
    for (int i = 0; i < boxes.size(); i++) {
      boxes.get(i).display();
    }
    p.display();
  }
}

void buildlevel() {
  if (debug) println("Building...");
  for (int i = 0; i < lvl1.length; i++) {
    int p = lvl1[i];
    if (debug) println("Adding " + p);
    Box b = new Box(p, dim, dim);
    if (debug) println("Box " + p + " built");
    boxes.add(b);
  }
  state = "level";
  if (debug) println("Finished building!");
}

void keyPressed() {
  int d = 2;
  if (key == CODED) {
    if (keyCode == UP) {
      p.move(0, -1);
    } else if (keyCode == DOWN) {
      p.move(0, 1);
    } else if (keyCode == LEFT) {
      p.move(-1, 0);
    } else if (keyCode == RIGHT) {
      p.move(1, 0);
    }
  }
}

int[] getPosition(int boxId) {
  int[] pos = {
    2 * dim + (boxId % 26) * dim, 2 * dim + (boxId - boxId % 26) / 26 * dim
  };
  return pos;
}

boolean boxThere(int boxId) {
  //println("searching...");
  for (int i = 0; i < boxes.size(); i++) {
    //println(lvl1[i]);
    if (boxes.get(i).getPos() == boxId) {
      //println("found!");
      return true;
    }
  }
  return false;
}

boolean moveBoxes(int boxId, int xdiff, int ydiff) {
  //println("Is there a box at " + (boxId+xdiff+ydiff*26) + "? " + boxThere(boxId+xdiff+ydiff*26));
  //println("Is there a box at " + (boxId+2*xdiff+2*ydiff*26) + "? " + boxThere(boxId+2*xdiff+2*ydiff*26));
  if (boxThere(boxId + xdiff + ydiff * 26)) {
    if (!boxThere(boxId + 2 * xdiff + 2 * ydiff * 26)) {
      // get correct box
      for (int i = 0; i < boxes.size(); i++) {
        if (boxes.get(i).getPos() == boxId + xdiff + ydiff * 26) {
          //println("box found! moving!");
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
    //println("New position of box:" + boxId);
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
