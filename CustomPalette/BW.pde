PImage makeBW(PImage src) {
  PImage bw = createImage(src.width, src.height, RGB);
  for(int i = 0; i < src.pixels.length; i++) {
    color c = src.pixels[i];
    float brightness = (c >> 16 & 0xFF) + (c >> 8 & 0xFF) + (c & 0xFF);
    brightness /= 3;
    bw.pixels[i] = color(brightness);
  }
  
  return bw;
}
