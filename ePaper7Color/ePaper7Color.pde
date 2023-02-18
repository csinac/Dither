color[] palette = {
  color(255, 0, 0),
  color(255, 255, 255),
  color(0, 255, 0),
  color(0, 0, 255),
  color(255, 255, 0),
  color(255, 128, 0),
  color(0, 0, 0)
};

PImage img;
boolean init = true;
KernelLoader kernelLoader;

void setup() {
  kernelLoader = new KernelLoader("../shared/kernels.json");
  img = loadImage("../shared/images/kelebekler.jpg");

  surface.setResizable(true);
  surface.setSize(img.width, img.height);  
}

void draw() {
  if (init) {
    image(img, 0, 0);
    init = false;
  }
}

void keyPressed() {
  if (key == 'f') {
    PImage dithered = dither(img, palette, "FloydSteinberg");
    background(dithered);
  } else if (key == 's') {
    PImage dithered = dither(img, palette, "Stucki");
    background(dithered);
  } else if (key == 'j') {
    PImage dithered = dither(img, palette, "JarvisJudiceNinke");
    background(dithered);
  } else if (key == 'i') {
    PImage dithered = dither(img, palette, "Sierra");
    background(dithered);
  } else if (key == 'a') {
    PImage dithered = dither(img, palette, "Atkinson");
    background(dithered);
  } else if (key == 'o') {
    background(img);
  }
}
