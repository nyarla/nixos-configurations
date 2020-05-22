{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    wget
    bind
    keychain # mosh
  ];
}
