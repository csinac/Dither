PImage dither(PImage src, color[] palette, String method) {
  PImage dithered = createImage(src.width, src.height, RGB);
  Kernel kernel = kernelLoader.get(method);

  if(kernel == null) {
    println("No dithering kernel found with the name " + method);
    return dithered;
  }
  
  for(int i = 0; i < src.pixels.length; i++)
    dithered.pixels[i] = src.pixels[i];
    
  for (int y = 0; y < dithered.height; y++) {
    for (int x = 0; x < dithered.width; x++) {
      color c = dithered.pixels[y * dithered.width + x];
      color match = getClosest(c, palette, true);
      float[] error = subtract(c, match);
      
      dithered.pixels[y * dithered.width + x] = match;

      int sizeHalf = kernel.size / 2;
      int lenHalf = kernel.size * kernel.size / 2 + 1;
      
      for(int v = 0; v < kernel.values.length; v++) {
        int shifted = v + lenHalf;
        
        int i = shifted % kernel.size;
        int j = (shifted - i) / kernel.size;
        
        int xx = x + i - sizeHalf;
        int yy = y + j - sizeHalf;

        if(xx >= 0 && yy >= 0 && xx < dithered.width && yy < dithered.height) {
          color neighbour = dithered.pixels[yy * src.width + xx];
          float[] ex = multiply(error, kernel.values[v]);
          dithered.pixels[yy * dithered.width + xx] = add(neighbour, ex);
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
