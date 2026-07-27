{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      proton-ge-rtsp-bin
      proton-rtsp-bin
    ];
    protontricks.enable = true;
  };

  hardware.steam-hardware.enable = true;
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  environment.etc."compatibilitytools.d/Proton-GE".source = pkgs.proton-ge-bin.steamcompattool;
  environment.etc."compatibilitytools.d/Proton-GE-rtsp".source =
    pkgs.proton-ge-rtsp-bin.steamcompattool;
  environment.etc."compatibilitytools.d/Proton-RTSP".source = pkgs.proton-rtsp-bin.steamcompattool;

  services.joycond.enable = true;
  boot.kernelModules = [ "hid_nintendo" ];

  hardware.uinput.enable = true;
}
