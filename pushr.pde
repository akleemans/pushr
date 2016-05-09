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
  if (debug) println("Building...");
  for (int i = 0; i < lvl1.length; i++) {
    int p = lvl1[i];
    if (debug) println("Adding " + p);
    //Box b = new Box(p, dim, dim);
    if (debug) println("Box " + p + " built");
    boxes.add(b);
  }
  state = "level";
  if (debug) println("Finished building!");
}

int[] getPosition(int boxId) {
  int[] pos = {
    2 * dim + (boxId % 26) * dim, 2 * dim + (boxId - boxId % 26) / 26 * dim
  };
  return pos;
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
