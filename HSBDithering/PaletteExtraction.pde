color[] extractDominantColors(PImage img, int count, float stride) {
  color[] palette = new color[count];
  int[] buckets = new int[256 * 256 * 256];

  img.loadPixels();
  
  for(int i = 0; i < img.pixels.length; i++) {
    int r = round(red(img.pixels[i]));
    int g = round(green(img.pixels[i]));
    int b = round(blue(img.pixels[i]));
    
    buckets[r * 256 * 256 + g * 256 + b]++;
  }
  
  DominanceData[] data = new DominanceData[count];
  for(int i = 0; i < count; i++)
    data[i] = new DominanceData();
  
  for(int r = 0; r < 256; r++) {
    for(int g = 0; g < 256; g++) {
      for(int b = 0; b < 256; b++) {
        tryPush(data, r, g, b, buckets[r * 256 * 256 + g * 256 + b]);
      }
    }
  }
  
  for(int i = 0; i < count; i++) {
    println(data[i].count, data[i].r, data[i].g, data[i].b);

    palette[i] = color(data[i].r * 10, data[i].g * 10, data[i].b * 10);
  }

  
  return palette;
}

void tryPush(DominanceData[] data, int r, int g, int b, int c) {
  for(int i = 0; i < data.length; i++) {
    if(c > data[i].count) {
      for(int j = data.length - 1; j > i; j--) {
        data[j].clone(data[j-1]);        
      }
      
      data[i].set(c, r, g, b);
      return;
    }
  }
}

class DominanceData {
  DominanceData() {
    count = -1;
    r = g = b = 0;
  }
  
  void clone(DominanceData other) {
    count = other.count;
    r = other.r;
    g = other.g;
    b = other.b;
  }
  
  void set(int nc, int nr, int ng, int nb) {
    count = nc;
    r = nr;
    g = ng;
    b = nb;
  }
    
  int count, r, g, b;
}
