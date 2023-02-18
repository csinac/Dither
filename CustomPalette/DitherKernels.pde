int fsSize = 3;
float[][] floydSteinbergKernel = {
  {0       , 0       , 0       },
  {0       , 0       , 7f / 16f},
  {3f / 16f, 5f / 16f, 1f / 16f},
};

int sSize = 5;
float[][] stuckiKernel = {
  {0       , 0       , 0       , 0       , 0       },
  {0       , 0       , 0       , 0       , 0       },
  {0       , 0       , 0       , 8f / 42f, 4f / 42f},
  {2f / 42f, 4f / 42f, 8f / 42f, 4f / 42f, 2f / 42f},
  {1f / 42f, 2f / 42f, 4f / 42f, 2f / 42f, 1f / 42f},
};

int jSize = 5;
float[][] jarvisJudiceNinkeKernel = {
  {0       , 0       , 0       , 0       , 0       },
  {0       , 0       , 0       , 0       , 0       },
  {0       , 0       , 0       , 7f / 48f, 5f / 48f},
  {3f / 48f, 5f / 48f, 7f / 48f, 5f / 48f, 3f / 48f},
  {1f / 48f, 3f / 48f, 5f / 48f, 3f / 48f, 1f / 48f},
};

int sierraSize = 5;
float[][] sierraKernel = {
  {0       , 0       , 0       , 0       , 0       },
  {0       , 0       , 0       , 0       , 0       },
  {0       , 0       , 0       , 5f / 32f, 3f / 32f},
  {2f / 32f, 4f / 32f, 5f / 32f, 4f / 32f, 2f / 32f},
  {0       , 2f / 32f, 3f / 32f, 2f / 32f, 0       },
};

int atkinsonSize = 5;
float[][] atkinsonKernel = {
  {0      , 0      , 0      , 0      , 0      },
  {0      , 0      , 0      , 0      , 0      },
  {0      , 0      , 0      , 1f / 8f, 1f / 8f},
  {0      , 1f / 8f, 1f / 8f, 1f / 8f, 0      },
  {0      , 0      , 1f / 8f, 0      , 0      },
};
