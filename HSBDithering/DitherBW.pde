PImage dither(HSB[] src, int w, int h, float[] palette, String method) {
  Kernel kernel = kernelLoader.get(method);

  if(w * h != src.length)
    return null;
    
  if(kernel == null) {
    println("No dithering kernel found with the name " + method);
    return null;
  }

  float[] dithered = new float[src.length];
  for(int i = 0; i < src.length; i++)
    dithered[i] = (float)src[i].b;
  
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      float c = dithered[y * w + x];
      float match = getClosest(c, palette);
      float error = c - match;
      
      dithered[y * w + x] = match;

      int sizeHalf = kernel.size / 2;
      int lenHalf = kernel.size * kernel.size / 2 + 1;

      for(int v = 0; v < kernel.values.length; v++) {
        int shifted = v + lenHalf;
        
        int i = shifted % kernel.size;
        int j = (shifted - i) / kernel.size;
        
        int xx = x + i - sizeHalf;
        int yy = y + j - sizeHalf;

        if(xx >= 0 && yy >= 0 && xx < w && yy < h) {
          float neighbour = dithered[yy * w + xx];
          float ex = error * kernel.values[v];
          dithered[yy * w + xx] = max(0, min(neighbour + ex, 255));
        }
      }
    }
  }
  
  return makeRGBImage(dithered, w, h);
}

float getClosest(float c, float[] palette) {
  int closest = -1;
  float delta = Float.MAX_VALUE;
  
  for(int i = 0; i < palette.length; i++) {    
    
    float dist = (c - palette[i]) / 255;
    dist = dist * dist;
            
    if(dist < delta) {
      delta = dist;
      closest = i;
    }    
  }
  
  return palette[closest];
}
