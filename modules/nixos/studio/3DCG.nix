{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    alcom
    pkgsRocm.blender
  ];
}
