{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.mod.sandbox.shell.rust-desktop;
in
{
  options.mod.sandbox.shell.rust-desktop = {
    enable = mkEnableOption "shellbox for Rust with Desktop App";
    dotDir = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    mod.security.sandbox.shell.features.desktop.enable = true;
    mod.security.sandbox.shell.settings.mounts.rw = [ cfg.dotDir ];
    mod.security.sandbox.shell.apps.rust-desktop = {
      bind =
        let
          uid = toString config.mod.security.sandbox.settings.user.uid;

          HOME = config.mod.security.sandbox.settings.user.home;
          XDG_RUNTIME_DIR = "/run/user/${uid}";
        in
        {
          rw = [
            cfg.dotDir
            "${XDG_RUNTIME_DIR}/wayland-0"
            "${XDG_RUNTIME_DIR}/pulse/native"
          ];

          ro = [
            "${HOME}/.config/gtk-2.0"
            "${HOME}/.config/gtk-3.0"
            "${HOME}/.config/gtk-4.0"

            "${HOME}/.local/share/fonts"
            "${HOME}/.local/share/icons"
            #  "${HOME}/.local/share/themes"

            # "${HOME}/.nix-profile/share/fonts"
            "${HOME}/.nix-profile/share/icons"
            "${HOME}/.nix-profile/share/themes"
          ];
        };

      packages = with pkgs; [
        rustup

        # for egui
        pkg-config
        wayland-protocols
        wayland-scanner

        dbus
        fontconfig
        freetype
        gtk3
        libGL
        libglvnd
        libx11
        libxcb
        libxcursor
        libxi
        libxinerama
        libxkbcommon
        mesa
        vulkan-loader
        wayland
      ];
    };
  };
}
