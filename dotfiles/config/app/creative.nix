{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gimp
    inkscape
    krita
    libresprite

    carla
    ildaeil
  ];
}
