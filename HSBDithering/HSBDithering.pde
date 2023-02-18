HSB[] palette;
color[] bwPalette;
PImage img;
PImage bw;
HSB[] hsbArray;

KernelLoader kernelLoader;
int hsCount = 16;
int bwCount = 8;


boolean init = true;

void setup() {
  kernelLoader = new KernelLoader("../shared/kernels.json");
  img = loadImage("../shared/images/kelebekler.jpg");
  hsbArray = getHSBArray(img);
  
  surface.setResizable(true);
  surface.setSize(img.width, img.height);
  
  palette = reducedPalette(hsbArray, hsCount);
  
  bw = makeBW(img);
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
    PImage dithered = dither(hsbArray, img.width, img.height, palette, "FloydSteinberg");
    background(dithered);
  } else if (key == 's') {
    PImage dithered = dither(hsbArray, img.width, img.height, palette, "Stucki");
    background(dithered);
  } else if (key == 'j') {
    PImage dithered = dither(hsbArray, img.width, img.height, palette, "JarvisJudiceNinke");
    background(dithered);
  } else if (key == 'i') {
    PImage dithered = dither(hsbArray, img.width, img.height, palette, "Sierra");
    background(dithered);
  } else if (key == 'a') {
    PImage dithered = dither(hsbArray, img.width, img.height, palette, "Atkinson");
    background(dithered);
  } else if (key == 'o') {
    background(img);
  }
}
