{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    yubioath-flutter
  ];

  services.udev.packages = [
    pkgs.yubioath-flutter
  ];
  services.pcscd.enable = true;

  security.pam.u2f.settings.cue = true;
  security.pam.services = {
    sudo.u2fAuth = true;
    polkit-1.u2fAuth = true;
    login.u2fAuth = true;
  };
}
