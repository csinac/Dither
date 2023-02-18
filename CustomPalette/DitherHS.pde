PImage kernelDither(HSB[] src, int w, int h, HSB[] palette, float[][] kernel, int kernelSize) {
  if(w * h != src.length)
    return null;
    
  HSB[] dithered = new HSB[src.length];
  for(int i = 0; i < src.length; i++)
    dithered[i] = new HSB(src[i]);
  
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      HSB c = dithered[y * w + x];
      HSB match = getClosestHS(c, palette);
      float[] error = subtract(c, match);
      
      dithered[y * w + x] = match;
      
      int kh = kernelSize / 2;
      for(int i = kh; i < kernelSize; i++) {
        for(int j = 0; j < kernelSize; j++) {
          int xx = x + j - kh;
          int yy = y + i - kh;

          if(xx >= 0 && yy >= 0 && xx < w && yy < h) {
            HSB neighbour = dithered[yy * w + xx];
            float[] ex = multiply(error, kernel[i][j]);
            dithered[yy * w + xx] = add(neighbour, ex);
          }
        }
      }
    }
  }
  
  return makeRGBImage(dithered, w, h);
}

HSB getClosestHS(HSB c, HSB[] palette) {
  int closest = -1;
  float delta = Float.MAX_VALUE;
  
  for(int i = 0; i < palette.length; i++) {    
    HSB p = palette[i];
    
    float dh = (float)(c.h - p.h);
    float ds = (float)(c.s - p.s);
    
    dh /= 255;
    ds /= 255;
        
    float distance = pow(dh, 2) + pow(ds, 2);
    if(distance < delta) {
      delta = distance;
      closest = i;
    }    
  }
  
  return palette[closest];
}

float[] subtract(HSB a, HSB b) {
    return new float[] { (float)(a.h - b.h), (float)(a.s - b.s), (float)(a.b - b.b) };
}

HSB add(HSB a, HSB b) {
    float r = max(0, min((float)(a.h + b.h), 255));
    float g = max(0, min((float)(a.s + b.s), 255));
    float l = max(0, min((float)(a.b + b.b), 255));

    return new HSB(r, g, l);
}

HSB add(HSB a, float[] b) {
    float br = b[0];
    float bg = b[1];
    float bb = b[2];
    
    float r = max(0, min((float)a.h + br, 255));
    float g = max(0, min((float)a.s + bg, 255));
    float l = max(0, min((float)a.b + bb, 255));

    return new HSB(r, g, l);
}
