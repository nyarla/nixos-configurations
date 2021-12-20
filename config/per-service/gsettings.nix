{ config, pkgs, lib, ... }:
let
  add-to-xdg-dirs = p: ''
     if test -d "${p}/share"; then
      case "''${XDG_DATA_DIRS}" in
        *:${p}/share:*) ;;
        *) export XDG_DATA_DIRS=''${XDG_DATA_DIRS}''${XDG_DATA_DIRS:+:}${p}/share
      esac
    fi

    if test -d "${p}/lib/girepository-1.0"; then
      case "''${GI_TYPELIB_PATH}" in
        *:${p}/lib/girepository-1.0:*) ;;
        *) export GI_TYPELIB_PATH=''${GI_TYPELIB_PATH}''${GI_TYPELIB_PATH:+:}${p}/lib ;;  
      esac

      case "''${LD_LIBRARY_PATH}" in
        *:${p}/lib:*) ;;
        *) export LD_LIBRARY_PATH=''${LD_LIBRARY_PATH}''${LD_LIBRARY_PATH:+:}${p}/lib ;;
      esac
    fi

    if test -d "${p}/lib/gio" ; then
      case "''${GIO_EXTRA_MODULES}" in
        *:${p}/lib/gio/modules:*) ;;
        *) export GIO_EXTRA_MODULES=''${GIO_EXTRA_MODULES}''${GIO_EXTRA_MODULES:+:}${p}/lib/gio/modules ;;
      esac
    fi 
  '';

  nixos-gsettings-overrides = pkgs.runCommand "nixos-gsettings-overrides" { } ''
    mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
    cp -rf ${pkgs.gnome3.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas*/glib-2.0/schemas/*.xml \
      $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/

    ${lib.concatMapStrings (p: ''
      if test -d ${p}/share/gsettings-schemas; then
        cp -rf ${p}/share/gsettings-schemas/*/glib-2.0/schemas/* \
          $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
      fi
    '')
    (config.environment.systemPackages ++ [ config.i18n.inputMethod.package ])}

    ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
  '';

in {
  environment.etc."profile.d/gsettings" = {
    text = ''
      export NIX_GSETTINGS_OVERRIDES_DIR=${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas

      ${pkgs.lib.concatMapStrings (p: ''
        ${add-to-xdg-dirs p}
      '') config.environment.systemPackages}
    '';
  };
}
