PImage reduceColors(PImage src, int n) {
  PImage reduced = createImage(src.width, src.height, RGB);
  float[][] rgbArray = new float[src.width * src.height][3];
  int idx = 0;
  
  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      int c = src.get(x, y);
      rgbArray[idx][0] = red(c);
      rgbArray[idx][1] = green(c);
      rgbArray[idx][2] = blue(c);
      idx++;
    }
  }

  float[][] clusters = cluster(rgbArray, n, 3);
  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      int c = img.get(x, y);
      int r = (int) red(c);
      int g = (int) green(c);
      int b = (int) blue(c);

      int index = 0;
      float minDist = Float.MAX_VALUE;
      for (int i = 0; i < clusters.length; i++) {
        float dist = dist(r, g, b, clusters[i][0], clusters[i][1], clusters[i][2]);
        if (dist < minDist) {
          index = i;
          minDist = dist;
        }
      }

      reduced.set(x, y, color(clusters[index][0], clusters[index][1], clusters[index][2]));
    }
  }
  
  return reduced;
}

color[] reducedPalette(PImage src, int count) {
  float[][] rgbArray = new float[src.width * src.height][3];
  int idx = 0;
  
  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      int c = src.get(x, y);
      rgbArray[idx][0] = red(c);
      rgbArray[idx][1] = green(c);
      rgbArray[idx][2] = blue(c);
      idx++;
    }
  }

  float[][] clusters = cluster(rgbArray, count, 3);
  color[] reduced = new color[count];
  for(int i = 0; i < count; i++) {
    reduced[i] = color(clusters[i][0], clusters[i][1], clusters[i][2]);
  }
  
  return reduced;
}

HSB[] reducedPalette(HSB[] src, int count) {
  float[][] array = new float[src.length][2];
  int idx = 0;
  
  for (int i = 0; i < src.length; i++) {
    array[idx][0] = (float)src[i].h;
    array[idx][1] = (float)src[i].s;
    idx++;
  }

  float[][] clusters = cluster(array, count, 2);
  HSB[] reduced = new HSB[count];
  for(int i = 0; i < count; i++) {
    reduced[i] = new HSB(clusters[i][0], clusters[i][1], 128f);
  }
  
  return reduced;
}

float[][] cluster(float[][] array, int count, int dim) {
  float[][] dominantColours = new float[count][dim];
  
  for (int i = 0; i < count; i++) {
    int r = (int) random(array.length);
    for(int j = 0; j < dim; j++)
      dominantColours[i][j] = array[r][j];
  }

  boolean converged = false;
  for (int f = 0; f < 99 && !converged; f++) {
    int[] assignments = new int[array.length];
    
    for (int i = 0; i < array.length; i++) {
      int[] values = new int[dim];
      for (int j = 0; j < dim; j++)
        values[j] = (int) array[i][j];
      
      int closestColorIndex = 0;
      float minDist = Float.MAX_VALUE;
      for (int j = 0; j < dominantColours.length; j++) {
        float distance = 0;
        for(int k = 0; k < dim; k++)
          distance += pow(values[k] - dominantColours[j][k], 2);  
        distance = sqrt(distance);

        if (distance < minDist) {
          closestColorIndex = j;
          minDist = distance;
        }
      }
      
      assignments[i] = closestColorIndex;
    }
    
    float[][] clusterMean = new float[count][dim];
    int[] clusterSizes = new int[count];
    
    for (int i = 0; i < array.length; i++) {
      int closestIndex = assignments[i];
      
      for (int j = 0; j < dim; j++)
        clusterMean[closestIndex][j] += array[i][j];

      clusterSizes[closestIndex]++;
    }
    
    for (int i = 0; i < count; i++) {
      for (int j = 0; j < dim; j++)
        clusterMean[i][j] /= clusterSizes[i];
    }
    
    converged = true;
    
    for (int i = 0; i < count && converged; i++) {
      for (int j = 0; j < dim; j++) {
        if (abs(dominantColours[i][j] - clusterMean[i][j]) > 1) {
          converged = false;
          break;
        }
      }
    }
    
    dominantColours = clusterMean;
  }
  
  return dominantColours;
}
