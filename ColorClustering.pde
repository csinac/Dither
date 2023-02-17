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

  float[][] clusters = cluster(rgbArray, n);
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

  float[][] clusters = cluster(rgbArray, count);
  color[] reduced = new color[count];
  for(int i = 0; i < count; i++) {
    reduced[i] = color(clusters[i][0], clusters[i][1], clusters[i][2]);
  }
  
  return reduced;
}

float[][] cluster(float[][] rgbArray, int count) {
  float[][] dominantColours = new float[count][3];
  
  for (int i = 0; i < count; i++) {
    int r = (int) random(rgbArray.length);
    dominantColours[i][0] = rgbArray[r][0];
    dominantColours[i][1] = rgbArray[r][1];
    dominantColours[i][2] = rgbArray[r][2];
  }

  boolean converged = false;
  for (int f = 0; f < 99 && !converged; f++) {
    //println(f);
    int[] assignments = new int[rgbArray.length];
    for (int i = 0; i < rgbArray.length; i++) {
      int r = (int) rgbArray[i][0];
      int g = (int) rgbArray[i][1];
      int b = (int) rgbArray[i][2];
      
      int closestColorIndex = 0;
      float minDist = Float.MAX_VALUE;
      for (int j = 0; j < dominantColours.length; j++) {
        float distance = dist(r, g, b, dominantColours[j][0], dominantColours[j][1], dominantColours[j][2]);
        if (distance < minDist) {
          closestColorIndex = j;
          minDist = distance;
        }
      }
      
      assignments[i] = closestColorIndex;
    }
    
    float[][] clusterMean = new float[count][3];
    int[] clusterSizes = new int[count];
    
    for (int i = 0; i < rgbArray.length; i++) {
      int closestIndex = assignments[i];
      
      clusterMean[closestIndex][0] += rgbArray[i][0];
      clusterMean[closestIndex][1] += rgbArray[i][1];
      clusterMean[closestIndex][2] += rgbArray[i][2];
      clusterSizes[closestIndex]++;
    }
    
    for (int i = 0; i < count; i++) {
      clusterMean[i][0] /= clusterSizes[i];
      clusterMean[i][1] /= clusterSizes[i];
      clusterMean[i][2] /= clusterSizes[i];
    }
    
    converged = true;
    
    for (int i = 0; i < count; i++) {
      if (abs(dominantColours[i][0] - clusterMean[i][0]) > 1 ||
          abs(dominantColours[i][1] - clusterMean[i][1]) > 1 ||
          abs(dominantColours[i][2] - clusterMean[i][2]) > 1) {
            converged = false;
            break;
       }
     }
     
     dominantColours = clusterMean;
   }
   
   return dominantColours;
 }
