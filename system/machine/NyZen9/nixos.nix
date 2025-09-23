{ pkgs, ... }:
{
  system.stateVersion = "24.11";

  nixpkgs.config.permittedInsecurePackages = [ ];

  environment.systemPackages = with pkgs; [ wpa_supplicant ];
}
