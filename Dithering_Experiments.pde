color[] palette = {
  color(255, 0, 0),
  color(255, 255, 255),
  color(0, 255, 0),
  color(0, 0, 255),
  color(255, 255, 0),
  color(255, 128, 0),
  color(0, 0, 0)
};

color[] dominantPalette;
HSB[] dominantHS;
color[] bwPalette;
PImage img;
PImage bw;
PImage rgb;
HSB[] hsbArray;

int colorCount = 8;
int bwCount = 8;

boolean init = true;

void setup() {
  img = loadImage("kelebekler.jpg");
  hsbArray = getHSBArray(img);
  
  surface.setResizable(true);
  surface.setSize(img.width, img.height);
  
  dominantPalette = reducedPalette(img, colorCount);
  dominantHS = reducedPalette(hsbArray, colorCount);
  
  bw = blackAndWhite(img);
  bwPalette = new color[bwCount];
  for (int i = 0; i < bwCount; i++)
    bwPalette[i] = color(255f * i / (bwCount - 1));
}

void draw() {
  if (init) {
    image(img, 0, 0);
    init = false;
  }
}

void keyPressed() {
  if (key == 'f') {
    PImage dithered = kernelDither(hsbArray, img.width, img.height, dominantHS, floydSteinbergKernel, fsSize);
    background(dithered);
  } else if (key == 's') {
    PImage dithered = kernelDither(hsbArray, img.width, img.height, dominantHS, stuckiKernel, sSize);
    background(dithered);
  } else if (key == 'j') {
    PImage dithered = kernelDither(hsbArray, img.width, img.height, dominantHS, jarvisJudiceNinkeKernel, jSize);
    background(dithered);
  } else if (key == 'i') {
    PImage dithered = kernelDither(hsbArray, img.width, img.height, dominantHS, sierraKernel, sierraSize);
    background(dithered);
  } else if (key == 'a') {
    PImage dithered = kernelDither(hsbArray, img.width, img.height, dominantHS, atkinsonKernel, atkinsonSize);
    background(dithered);
  } else if (key == ' ') {
    background(img);
  } else if (key == 'w') {
    PImage dithered = kernelDither(bw, bwPalette, atkinsonKernel, atkinsonSize);
    background(dithered);
  } else if (key == 'o') {
    background(img);
  }

  /*
  if (key == 'f') {
    PImage dithered = kernelDither(img, dominantPalette, floydSteinbergKernel, fsSize);
    background(dithered);
  } else if (key == 's') {
    PImage dithered = kernelDither(img, dominantPalette, stuckiKernel, sSize);
    background(dithered);
  } else if (key == 'j') {
    PImage dithered = kernelDither(img, dominantPalette, jarvisJudiceNinkeKernel, jSize);
    background(dithered);
  } else if (key == 'i') {
    PImage dithered = kernelDither(img, dominantPalette, sierraKernel, sierraSize);
    background(dithered);
  } else if (key == 'a') {
    PImage dithered = kernelDither(img, dominantPalette, atkinsonKernel, atkinsonSize);
    background(dithered);
  } else if (key == ' ') {
    background(img);
  } else if (key == 'w') {
    PImage dithered = kernelDither(bw, bwPalette, atkinsonKernel, atkinsonSize);
    background(dithered);
  } else if (key == 'o') {
    background(rgb);
  }
  */
}
