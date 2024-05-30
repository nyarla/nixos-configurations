{ pkgs, ... }:
{
  imports = [ ./gnome-compatible.nix ];
  environment.systemPackages = with pkgs; [ xclip ];

  console.useXkbConfig = true;
  services.pipewire.enable = true;
  services.xserver = {
    enable = true;
    autorun = false;
    exportConfiguration = true;

    displayManager = {
      lightdm.enable = false;
    };
  };
}
