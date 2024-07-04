_final: prev: {
  opencascade-occt = prev.opencascade-occt_0_17.override {
    buildInputs = with prev; [
      tcl
      tk
      libGL
      libGLU
      libXext
      libXmu
      libXi
      vtk
      xorg.libXt
      freetype
      freeimage
      fontconfig
      tbb_2021_11
      rapidjson
      glew
    ] ++ vtk.buildInputs;
  };
}
