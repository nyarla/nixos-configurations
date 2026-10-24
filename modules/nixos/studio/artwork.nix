{ pkgs, ... }: {
  environment.systemPackages =
    with pkgs;
    [
      gimp3
      gimp-shell

      krita

      inkscape

      aseprite
    ]
    ++ (with artcraft; [
      cadcraft
      designcraft
      figcraft
      photocraft
      vectorcraft
    ]);
}
