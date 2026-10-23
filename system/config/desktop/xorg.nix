{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ xclip ];

  console.useXkbConfig = true;
  services.xserver = {
    enable = true;
    autorun = false;
    exportConfiguration = true;

    displayManager = {
      lightdm.enable = false;
    };
  };
}
