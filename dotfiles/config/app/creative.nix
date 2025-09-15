{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # for edit graphics
    gimp3
    inkscape
    krita

    # for pixel arts
    aseprite
    pixelorama

    # for 3D modeling
    blender-hip
  ];
}
