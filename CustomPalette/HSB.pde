class HSB {
  double h, s, b;
  
  HSB() {}
  
  HSB(HSB hsb) {
    h = hsb.h;
    s = hsb.s;
    b = hsb.b;
  }

  HSB(float hue, float sat, float brg) {
    h = hue;
    s = sat;
    b = brg;
  }
  
  String toString() {
    return "H: " + h + " S: " + s + " B: " + b;
  }
}

color hsb2rgb(HSB in) {
    if (in.s <= 0) return color((int)in.b, (int)in.b, (int)in.b);
    in.s /= 255;

    double hh = 6 * in.h / 255;
    int i = (int)hh;
    double ff = hh - i;
    double p = in.b * (1 - in.s);
    double q = in.b * (1 - in.s * ff);
    double t = in.b * (1 - in.s * (1 - ff));

    switch (i) {
        case 0: return color((int)in.b, (int)t, (int)p);
        case 1: return color((int)q, (int)in.b, (int)p);
        case 2: return color((int)p, (int)in.b, (int)t);
        case 3: return color((int)p, (int)q, (int)in.b);
        case 4: return color((int)t, (int)p, (int)in.b);
        default: return color((int)in.b, (int)p, (int)q);
    }
}

float fmod(float f, float divider) {
  float output = f / divider;
  int sign = output < 0 ? -1 : 1;
  output = abs(output);
  
  return (output - floor(output)) * sign;
}

HSB rgb2hsb(color c) {
    float r = red(c);
    float g = green(c);
    float b = blue(c);

    HSB out = new HSB();
    double min = min(min(r, g), b);
    double max = max(max(r, g), b);
    out.b = max;
    double delta = max - min;

    if (delta < EPSILON) {
        out.s = 0;
        out.h = 0;
        return out;
    }

    out.s = (delta / max);
    if (r == max) {
        out.h = (g - b) / delta;
    } else if (g == max) {
        out.h = 2 + (b - r) / delta;
    } else {
        out.h = 4 + (r - g) / delta;
    }

    out.h /= 6;
    if (out.h < 0) {
        out.h += 1;
    }
    
    out.h *= 255;
    out.s *= 255;

    return out;
}

HSB[] getHSBArray(PImage img) {
  HSB[] array = new HSB[img.pixels.length];
  img.loadPixels();
  for(int i = 0; i < img.pixels.length; i++) {
    array[i] = rgb2hsb(img.pixels[i]);
  }
  
  return array;
}

PImage makeRGBImage(HSB[] array, int w, int h) {
  PImage rgbImg = createImage(w, h, RGB);
  
  for(int i = 0; i < array.length; i++) {
    rgbImg.pixels[i] = hsb2rgb(array[i]);
  }
    
  return rgbImg;
}
