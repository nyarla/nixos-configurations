{ pkgs, lib, ... }: {
  imports = [
    ../machine/NyZen9/default.nix

    ../config/desktop/wayland.nix
    ../config/desktop/xdg.nix
    ../config/desktop/xorg.nix
    ../config/gadgets/android.nix
    ../config/gaming/steam.nix
    ../config/gaming/xr.nix
    ../config/graphic/fonts.nix
    ../config/graphic/lodpi.nix
    ../config/hardware/firmware.nix
    ../config/i18n/fcitx5.nix
    ../config/i18n/locales.nix
    ../config/keyboard/us.nix
    ../config/keyboard/zinc.nix
    ../config/linux/console.nix
    ../config/linux/containers.nix
    ../config/linux/filesystem.nix
    ../config/linux/hardware.nix
    ../config/linux/lodpi.nix
    ../config/linux/optical.nix
    ../config/linux/optimize.nix
    ../config/linux/process.nix
    ../config/linux/waydroid.nix
    ../config/networking/agent.nix
    ../config/networking/avahi.nix
    ../config/networking/network-manager.nix
    ../config/networking/printer.nix
    ../config/networking/tailscale.nix
    ../config/nixos/gsettings.nix
    ../config/nixos/nix-ld.nix
    ../config/security/firewall-home.nix
    ../config/security/gnupg.nix
    ../config/security/ulimit.nix
    ../config/security/yubikey.nix
    ../config/tools/editors.nix
    ../config/tools/git.nix
    ../config/user/nyarla.nix
    ../config/video/intel-with-amd.nix
    ../config/vmm/kvm.nix

    ../config/services/nyzen9.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
    "nodejs-20.20.2"
    "nodejs-slim-20.20.2"
  ];

  environment.systemPackages = with pkgs; [
    (shellbox.override { baseDir = "/home/nyarla/Programming"; })
  ];
}
