HSB[] palette;
float[] bwPalette;
PImage img;
HSB[] hsbArray;

KernelLoader kernelLoader;
String method;
int hsCount = 8;
int bwCount = 4;

boolean init = true;

void setup() {
  kernelLoader = new KernelLoader("../shared/kernels.json");
  img = loadImage("../shared/images/kelebekler.jpg");
  hsbArray = getHSBArray(img);
  
  surface.setResizable(true);
  surface.setSize(img.width, img.height);
  
  palette = reducedHSPalette(hsbArray, hsCount);
  bwPalette = reducedBPalette(hsbArray, bwCount);  
}

void draw() {
  if (init) {
    image(img, 0, 0);
    init = false;
  }
}

boolean redraw = false;
void keyPressed() {
  if (key == 'f') {
    method = "FloydSteinberg";
    redraw = true;
  } else if (key == 's') {
    method = "Stucki";
    redraw = true;
  } else if (key == 'j') {
    method = "JarvisJudiceNinke";
    redraw = true;
  } else if (key == 'i') {
    method = "Sierra";
    redraw = true;
  } else if (key == 'a') {
    method = "Atkinson";
    redraw = true;
  } else if (key == 'o') {
    background(img);
  }
  
  if(redraw) {
    redraw = false;
    
    HSB[] hs = dither(hsbArray, img.width, img.height, palette, method);
    float[] b = dither(hsbArray, img.width, img.height, bwPalette, method);
    
    for(int i = 0; i < img.pixels.length; i++) {
      hs[i].b = b[i];
      img.pixels[i] = hsb2rgb(hs[i]);
    }
    
    background(img);
  }
}
