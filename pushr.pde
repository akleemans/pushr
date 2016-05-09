Border outer, inner;

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
  lvl = 0;
  size(width, height);
}

// main loop function
void draw() {
  background(0);
  if (debug) println("Building...");
  // TODO build level
  if (debug) println("Finished building!");
}
