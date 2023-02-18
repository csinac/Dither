PImage kernelDither(PImage src, color[] palette, float[][] kernel, int kernelSize) {
  PImage dithered = createImage(src.width, src.height, RGB);
  for(int i = 0; i < src.pixels.length; i++)
    dithered.pixels[i] = src.pixels[i];
  
  for (int y = 0; y < dithered.height; y++) {
    for (int x = 0; x < dithered.width; x++) {
      color c = dithered.pixels[y * dithered.width + x];
      color match = getClosest(c, palette, true);
      float[] error = subtract(c, match);
      
      dithered.pixels[y * dithered.width + x] = match;
      
      int kh = kernelSize / 2;
      for(int i = kh; i < kernelSize; i++) {
        for(int j = 0; j < kernelSize; j++) {
          int xx = x + j - kh;
          int yy = y + i - kh;

          if(xx >= 0 && yy >= 0 && xx < dithered.width && yy < dithered.height) {
            color neighbour = dithered.pixels[yy * src.width + xx];
            float[] ex = multiply(error, kernel[i][j]);
            dithered.pixels[yy * dithered.width + xx] = add(neighbour, ex);
          }
        }
      }
    }
  }
  
  return dithered;
}

PImage floydSteinbergDither(PImage src, color[] palette) {
  PImage dithered = createImage(src.width, src.height, RGB);
  for(int i = 0; i < src.pixels.length; i++)
    dithered.pixels[i] = src.pixels[i];
    
  for (int y = 0; y < dithered.height; y++) {
    for (int x = 0; x < dithered.width; x++) {
      color c = dithered.pixels[y * src.width + x];
      color match = getClosest(c, palette, true);
      float[] error = subtract(c, match);
      
      dithered.pixels[y * src.width + x] = match;

      if (!(x == dithered.width - 1)) {
        color nx = dithered.pixels[x + 1 + y * src.width];
        float[] ex = multiply(error, 7.0 / 16.0);
        
        dithered.pixels[x + 1 + y * src.width] = add(nx, ex);

        if (!(y == dithered.height - 1)) {
          nx = dithered.pixels[x + 1 + (y + 1) * src.width];
          ex = multiply(error, 1.0 / 16.0);

          dithered.pixels[x + 1 + (y + 1) * src.width] = add(nx, ex);
        }
      }

      if (!(y == dithered.height - 1))
      {
        color nx = dithered.pixels[x + (y + 1) * src.width];
        float[] ex = multiply(error, 3.0 / 16.0);

        dithered.pixels[x + (y + 1) * src.width] = add(nx, ex);

        if (!(x == 0)) {
          nx = dithered.pixels[x - 1 + (y + 1) * src.width];
          ex = multiply(error, 5.0 / 16.0);

          dithered.pixels[x - 1 + (y + 1) * src.width] = add(nx, ex);
        }
      }
    }
  }
  
  return dithered;
}


color getClosest(color c, color[] palette, boolean byteColor) {
  int closest = -1;
  float delta = Float.MAX_VALUE;
  
  for(int i = 0; i < palette.length; i++) {
    float cr = red(c);
    float cg = green(c);
    float cb = blue(c);
    
    float pr = red(palette[i]);
    float pg = green(palette[i]);
    float pb = blue(palette[i]);
    
    float dr = cr - pr;
    float dg = cg - pg;
    float db = cb - pb;
    
    if(byteColor) {
      dr /= 255;
      dg /= 255;
      db /= 255;
    }
        
    float distance = pow(dr, 2) + pow(dg, 2) + pow(db, 2);
    if(distance < delta) {
      delta = distance;
      closest = i;
    }
    
  }
  
  return palette[closest];
}

float[] subtract(color a, color b) {
    float ar = red(a);
    float ag = green(a);
    float ab = blue(a);

    float br = red(b);
    float bg = green(b);
    float bb = blue(b);
    
    return new float[] { ar - br, ag - bg, ab - bb };
}

color add(color a, color b) {
    float ar = red(a);
    float ag = green(a);
    float ab = blue(a);

    float br = red(b);
    float bg = green(b);
    float bb = blue(b);
    
    float r = max(0, min(ar + br, 255));
    float g = max(0, min(ag + bg, 255));
    float l = max(0, min(ab + bb, 255));

    return color(r, g, l);
}

color add(color a, float[] b) {
    float ar = red(a);
    float ag = green(a);
    float ab = blue(a);

    float br = b[0];
    float bg = b[1];
    float bb = b[2];
    
    float r = max(0, min(ar + br, 255));
    float g = max(0, min(ag + bg, 255));
    float l = max(0, min(ab + bb, 255));

    return color(r, g, l);
}

float[] multiply(float[] a, float b) {
  float[] result = new float[a.length];
  
  for(int i = 0; i < a.length; i++)
    result[i] = a[i] * b;
    
    return result;
}
