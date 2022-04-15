{ config, pkgs, lib, ... }:
let
  iconThemes = with pkgs; [
    capitaine-cursors
    flatery-icon-theme
    gnome.adwaita-icon-theme
    hicolor-icon-theme
  ];

  gtkThemes = with pkgs; [ victory-gtk-theme gnome3.gnome-themes-extra ];

  extra = with pkgs; [ gtk-engine-murrine gtk_engines ];

  global-icon-name = pkgs.callPackage ({ stdenv }:
    stdenv.mkDerivation rec {
      pname = "global-icon-name";
      version = "2021-11-16";
      dontUnpack = true;
      outputs = [ "out" ];
      installPhase = ''
        mkdir -p $out/share/icons/default
        cat << EOF > $out/share/icons/default/index.theme
        [Icon Theme]
        Name=Default
        Comment=Default Cursor Theme
        Inherits=capitaine-cursors-white,Flatery-Sky,Adwaita,hicolor
        EOF
      '';
    }) { };

  global-theme-settings = lib.generators.toINI { } {
    Settings = {
      gtk-icon-theme-name = "Default";
      gtk-cursor-theme-name = "Default";
      gtk-theme-name = "Victory";
    };
  };

  wrappedGTKGreeter = pkgs.runCommand "lightdm-gtk-greeter" {
    buildInputs = [ pkgs.makeWrapper ];
  } ''
    makeWrapper ${pkgs.lightdm_gtk_greeter}/bin/lightdm-gtk-greeter \
      $out/greeter \
      --prefix PATH : "${pkgs.glibc}/bin" \
      --set GDK_PIXBUF_MODULE_FILE "${pkgs.gdk_pixbuf.out}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache" \
      --set GTK_PATH "${config.system.path}" \
      --set GTK_EXE_PREFIX "${config.system.path}" \
      --set GTK_DATA_PREFIX "${config.system.path}" \
      --set GTK_THEME "Victory" \
      --set XDG_DATA_DIRS "${config.system.path}/share" \
      --set XDG_CONFIG_HOME "/etc/xdg" \
      --set XCURSOR_PATH "${config.system.path}/share/icons" \
      --set XCURSOR_SIZE "16"
    cat - > $out/lightdm-gtk-greeter.desktop << EOF
    [Desktop Entry]
    Name=LightDM Greeter
    Comment=This runs the LightDM Greeter
    Exec=$out/greeter
    Type=Application
    EOF
  '';
in {
  environment.pathsToLink = [ "/share" ];
  environment.variables = { QT_QPA_PLATFORMTHEME = "gtk3"; };
  environment.systemPackages = iconThemes ++ gtkThemes ++ extra
    ++ [ global-icon-name ];
  environment.etc."xdg/gtk-3.0/settings.ini" = {
    text = global-theme-settings;
    mode = "0444";
  };

  services.xserver = {
    displayManager = {
      lightdm = {
        greeter.package = wrappedGTKGreeter;
        greeters.gtk = {
          enable = true;
          theme = {
            package = pkgs.victory-gtk-theme;
            name = "Victory";
          };
          iconTheme = {
            package = pkgs.flatery-icon-theme;
            name = "Flatery-Sky";
          };
          cursorTheme = {
            package = pkgs.capitaine-cursors;
            name = "Default";
            size = 16;
          };
          clock-format = "%Y-%m-%d %H:%M:%S";
          indicators =
            [ "~host" "~spacer" "~clock" "~spacer" "~session" "~power" ];

          extraConfig = ''
            font-name = Sans
            background = ${
              pkgs.fetchurl {
                url =
                  "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-stripes-logo.png";
                sha256 = "0cqjkgp30428c1yy8s4418k4qz0ycr6fzcg4rdi41wkh5g1hzjnl";

              }
            }
          '';
        };
      };
    };
  };
}
