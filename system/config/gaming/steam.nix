{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      proton-ge-rtsp-bin
      proton-rtsp-bin
      proton-rtsp-wayland-ge-bin
    ];
    protontricks.enable = true;
  };

  hardware.steam-hardware.enable = true;
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  environment.etc = with pkgs; {
    "compatibilitytools.d/Proton-GE".source = proton-ge-bin.steamcompattool;
    "compatibilitytools.d/Proton-GE-rtsp".source = proton-ge-rtsp-bin.steamcompattool;
    "compatibilitytools.d/Proton-RTSP".source = pkgs.proton-rtsp-bin.steamcompattool;
    "compatibilitytools.d/Proton-RTSP-Wayland-GE".source =
      pkgs.proton-rtsp-wayland-ge-bin.steamcompattool;
  };

  services.joycond.enable = true;
  boot.kernelModules = [ "hid_nintendo" ];

  hardware.uinput.enable = true;
}
