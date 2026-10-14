{ lib, config, ... }:
with lib;
let
  cfg = config.my.security.box;
in
{
  options.my.security.box = {
    enable = mkEnableOption "security boxed app";
    apps = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }: {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
              };

              user = {
                home = mkOption { type = types.str; };
                user = mkOption { type = types.str; };
                group = mkOption { type = types.str; };
                extraGroups = mkOption { type = types.listOf types.str; };
                uid = mkOption { type = types.int; };
                gid = mkOption { type = types.int; };
              };

              wayland.enable = mkOption {
                type = types.bool;
                default = false;
              };

              audio.enable = mkOption {
                type = types.bool;
                default = false;
              };

              mounts = {
                ro = mkOption { type = types.listOf types.str; };
                rw = mkOption { type = types.listOf types.str; };
              };

              package = mkOption { type = types.package; };
              extraPackages = mkOption { type = types.listOf types.package; };

              environment = mkOption { type = types.attrsOf types.str; };

              command = mkOption { type = types.str; };
              extraInit = mkOption {
                type = types.str;
                default = "";
              };
            };
          }
        )
      );
    };

    locale = mkOption {
      type = types.attrsOf types.str;
      default = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };
    };

    inputMethod = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      type = mkOption { type = types.str; };
    };
  };

  config = mkIf cfg.enable {
    security.sudo.extraRules = attrsets.mapAttrsToList (name: opts: {
      users = [ opts.user.user ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-container run ${name} -- systemctl start ${name}.service";
          options = [ "NOPASSWD" ];
        }
      ];
    }) cfg.apps;

    containers = attrsets.mapAttrs (
      name: opts:
      let
        HOME = opts.user.home;
        XDG_RUNTIME_DIR = "/run/user/${toString opts.user.uid}";
      in
      {
        autoStart = true;

        bindMounts =
          (optionalAttrs opts.wayland.enable {
            "${HOME}/.config/gtk-2.0".isReadOnly = true;
            "${HOME}/.config/gtk-3.0".isReadOnly = true;
            "${HOME}/.config/gtk-4.0".isReadOnly = true;

            "${HOME}/.local/share/fonts".isReadOnly = true;
            "${HOME}/.local/share/icons".isReadOnly = true;
            #  "${HOME}/.local/share/themes".isReadOnly = true;

            # "${HOME}/.nix-profile/share/fonts".isReadOnly = true;
            "${HOME}/.nix-profile/share/icons".isReadOnly = true;
            "${HOME}/.nix-profile/share/themes".isReadOnly = true;

            "${XDG_RUNTIME_DIR}/wayland-0".isReadOnly = false;
          })
          // (optionalAttrs opts.audio.enable {
            "${XDG_RUNTIME_DIR}/pulse/native".isReadOnly = false;
          })
          // attrsets.mergeAttrsList (
            lists.forEach opts.mounts.ro (path: {
              "${path}".isReadOnly = true;
            })
          )
          // attrsets.mergeAttrsList (
            lists.forEach opts.mounts.rw (path: {
              "${path}".isReadOnly = false;
            })
          );

        config = { pkgs, ... }: {
          # NixOS
          system = {
            inherit (config.system) stateVersion;
          };

          systemd.tmpfiles.rules = [
            "d /run/user/${toString opts.user.uid} 700 ${opts.user.user} ${opts.user.group} - -"
            "d ${HOME} 700 ${opts.user.user} ${opts.user.group} - -"
          ]
          ++ (optional opts.audio.enable "d /run/user/${toString opts.user.uid}/pulse 700 ${opts.user.user} ${opts.user.group} - -");

          # locale
          i18n = {
            defaultLocale = "en_US.UTF-8";
            extraLocales = [ "ja_JP.UTF-8/UTF-8" ];
          };

          # time zone
          time.timeZone = "Asia/Tokyo";
          services.timesyncd = {
            enable = true;
            servers = [
              "ntp1.jst.mfeed.ad.jp"
              "ntp2.jst.mfeed.ad.jp"
              "ntp3.jst.mfeed.ad.jp"
            ];
          };

          # user and groups
          users.users.${opts.user.user} = {
            enable = true;
            isNormalUser = true;
            inherit (opts.user) uid;
            group = opts.user.group;
            extraGroups = opts.user.extraGroups or [ ];
          };

          users.groups.${opts.user.group} = {
            inherit (opts.user) gid;
          };

          # for wayland
          programs.dconf.enable = opts.wayland.enable;

          fonts =
            { }
            // (optionalAttrs opts.wayland.enable {
              inherit (config.fonts) packages;
              fontconfig = {
                enable = true;
                inherit (config.fonts.fontconfig) defaultFonts;
              };
            });

          # for application
          environment.systemPackages = [
            opts.package
          ]
          ++ opts.extraPackages
          ++ (optionalAttrs opts.wayland.enable (
            with pkgs;
            [
              gsettings-desktop-schemas
              gtk3
              gtk4
            ]
          ));

          systemd.services.${name} = {
            enable = true;
            path = [ opts.package ] ++ opts.extraPackages;
            environment = {
              inherit HOME XDG_RUNTIME_DIR;
            }
            // cfg.locale
            // (optionalAttrs opts.wayland.enable {
              GTK_THEME = "Fluent-Light-compact";

              XDG_DATA_DIRS = "${HOME}/.nix-profile/share:/run/current-system/sw/share";

              GDK_BACKEND = "wayland";
              CLUTTER_BACKEND = "wayland";
              QT_QPA_PLATFORM = "wayland";
              SDL_VIDEODRIVER = "wayland";

              NIX_GSETTINGS_OVERRIDES_DIR =
                let
                  nixos-gsettings-overrides = pkgs.runCommand "nixos-gsettings-overrides" { } ''
                    mkdir -p $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
                    cp -rf ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas*/glib-2.0/schemas/*.xml \
                      $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/

                    ${lib.concatMapStrings (p: ''
                      if test -d ${p}/share/gsettings-schemas; then
                        find ${p}/share/gsettings-schemas -name '*.xml' \
                          -exec cp -rfH {} $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/ \;
                      fi
                    '') (lib.lists.remove null config.environment.systemPackages)}

                    ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas/
                  '';
                in
                "${nixos-gsettings-overrides}/share/gsettings-schemas/nixos-gsettings-overrides/glib-2.0/schemas";
            })
            // (optionalAttrs cfg.inputMethod.enable {
              GTK_IM_MODULE = cfg.inputMethod.type;
              QT_IM_MODULE = cfg.inputMethod.type;
              XMODIFIER = "@im=${cfg.inputMethod.type}";
            })
            // opts.environment;

            serviceConfig = {
              Type = "simple";
              User = opts.user.user;
              Group = opts.user.group;
              ExecStartPre =
                pkgs.writeShellScript "pre-start.sh" (
                  optionalString opts.wayland.enable ''
                    ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface cursor-size 24
                    ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface cursor-theme capitaine-cursors-white
                    ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface font-name "Sans 9"
                    ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface gtk-theme "Fluent-Light-compact"
                    ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface icon-theme "Fluent-light"
                  ''
                )
                + opts.extraInit;
              ExecStart = "${lib.getExe' opts.package opts.command}";
            };
          };
        };
      }
    ) cfg.apps;
  };
}
