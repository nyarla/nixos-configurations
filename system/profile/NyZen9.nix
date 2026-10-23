{ pkgs, lib, ... }: {
  imports = [
    ../machine/NyZen9/default.nix

    ../config/audio/daw.nix
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
    ../config/wireless/AX200.nix
    ../config/wireless/bluetooth.nix

    ../config/services/nyzen9.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
    "nodejs-20.20.2"
    "nodejs-slim-20.20.2"
  ];

  # applications box
  my.security.box = {
    enable = true;
    locale = {
      LANG = "ja_JP.UTF-8";
      LC_ALL = "ja_JP.UTF-8";
    };
    inputMethod = {
      enable = true;
      type = "fcitx";
    };
  };

  my.box =
    let
      user = {
        user = "nyarla";
        group = "users";
        uid = 1000;
        gid = 100;
      };
    in
    {
      deadbeef = {
        enable = true;
        package = with pkgs; deadbeef-with-plugins.override { plugins = [ deadbeef-fb ]; };
        inherit user;
        library = "/backup/Music";
      };
    };

  # shell box
  my.security.shellbox = {
    enable = true;

    user = {
      user = "nyarla";
      group = "users";
      uid = 1000;
      gid = 100;
    };

    bind.rw = [ "/home/nyarla/Programming" ];

    extraPackages = with pkgs; [
      fzy
      starship
      zsh
    ];

    programs = {
      gnupg.enable = true;
      neovim.enable = true;
      pi-coding-agent.enable = true;
      proton-pass-cli.enable = true;
    };

    dotfiles =
      let
        file = path: { "/etc/nixos/files/shellbox/${path}" = "/home/nyarla/${path}"; };
      in
      {
        enable = true;
        files = lib.attrsets.mergeAttrsList (
          lib.lists.forEach [
            ".config/git/config"
            ".config/git/ignore"
            ".config/herdr/config.toml"
            ".config/starship.toml"
            ".zshrc"
          ] file
        );
      };
  };

  my.shellbox = {
    typescript = {
      enable = true;
      tag = "2026.10.3";
      ports = [ 1313 ];
    };
  };

  environment.systemPackages = with pkgs; [
    (shellbox.override { baseDir = "/home/nyarla/Programming"; })
  ];
}
