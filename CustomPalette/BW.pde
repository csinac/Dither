PImage blackAndWhite(PImage src) {
  PImage bw = createImage(src.width, src.height, RGB);
  for(int i = 0; i < src.pixels.length; i++) {
    float brightness = red(src.pixels[i]) + green(src.pixels[i]) + blue(src.pixels[i]);
    brightness /= 3;
    bw.pixels[i] = color(brightness);
  }
  
  return bw;
}
