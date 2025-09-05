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

  environment.etc."compatibilitytools.d/Proton-GE".source = pkgs.proton-ge-bin.steamcompattool;
  environment.etc."compatibilitytools.d/Proton-GE-rtsp".source =
    pkgs.proton-ge-rtsp-bin.steamcompattool;
}
