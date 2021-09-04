{ ... }: {
  services.compton = {
    enable = true;
    backend = "xrender";

    shadow = true;
    shadowOffsets = [ (-15) (-15) ];
    shadowOpacity = 0.2;
    shadowExclude = [ "class_g = 'Firefox' && argb" ];

    fade = true;
    fadeDelta = 10;
    fadeSteps = [ 0.25 0.25 ];

    vSync = true;

    settings = {
      shadow-radius = 15;
      unredir-if-possible = false;
    };
  };
}
