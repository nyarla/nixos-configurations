{ pkgs, ... }: {
  imports = [ ./gnome-compatible.nix ];
  environment.systemPackages = with pkgs; [ xclip ];

  console.useXkbConfig = true;
  services.pipewire.enable = true;
  services.xserver = {
    enable = true;
    autorun = false;
    libinput.enable = true;
    exportConfiguration = true;

    displayManager = {
      job.environment.LANG = "ja_JP.UTF-8";
      lightdm.enable = false;
    };
  };
}
