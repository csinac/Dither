HSB[] palette;
float[] bwPalette;
PImage img;
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
  
  palette = reducedHSPalette(hsbArray, hsCount);
  bwPalette = reducedBPalette(hsbArray, bwCount);
  
  for(int i = 0; i < bwPalette.length; i++)
    println(bwPalette[i]);
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
  } else if (key == 'b') {
    PImage dithered = dither(hsbArray, img.width, img.height, bwPalette, "Atkinson");
    background(dithered);
  } else if (key == 'o') {
    background(img);
  }
}
