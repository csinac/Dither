HSB[] reducedHSPalette(HSB[] src, int count) {
  float[][] array = new float[src.length][2];
  int idx = 0;
  
  for (int i = 0; i < src.length; i++) {
    array[idx][0] = (float)src[i].h;
    array[idx][1] = (float)src[i].s;
    idx++;
  }

  float[][] clusters = cluster(array, count, 2);
  HSB[] reduced = new HSB[count];
  for(int i = 0; i < count; i++)
    reduced[i] = new HSB(clusters[i][0], clusters[i][1], 128f);
  
  return reduced;
}

float[] reducedBPalette(HSB[] src, int count) {
  float[][] array = new float[src.length][1];
  int idx = 0;
  
  for (int i = 0; i < src.length; i++) {
    array[idx][0] = (float)src[i].b;
    idx++;
  }

  float[][] clusters = cluster(array, count, 1);
  float[] reduced = new float[count];
  for(int i = 0; i < count; i++)
    reduced[i] = clusters[i][0];
  
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
