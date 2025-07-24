{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      proton-ge-rtsp-bin
    ];
    protontricks.enable = true;
  };

  hardware.steam-hardware.enable = true;
}
