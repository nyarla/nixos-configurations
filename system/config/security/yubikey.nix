{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization
    yubikey-personalization-gui
  ];

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  security.pam.services = {
    sudo.u2fAuth = true;
    polkit-1.u2fAuth = true;
  };
}
