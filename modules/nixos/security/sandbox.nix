{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.mod.security.sandbox;
in
{
  options.mod.security.sandbox = {
    settings.user = {
      name = mkOption {
        type = types.str;
      };

      group = mkOption {
        type = types.str;
        default = "users";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };

      home = mkOption {
        type = types.str;
        default = "/home/${cfg.settings.user.name}";
      };

      uid = mkOption {
        type = types.int;
        default = 1000;
      };

      gid = mkOption {
        type = types.int;
        default = 100;
      };
    };

    settings.locale = mkOption {
      type = types.attrsOf types.str;
      default = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };
    };

    settings.theme = {
      gtk = mkOption { type = types.str; };
    };

    desktop.inputMethod = {
      enable = mkOption {
        type = types.bool;
        default = config.i18n.inputMethod.enable;
      };

      type = mkOption {
        type = types.str;
        default = config.i18n.inputMethod.type;
      };
    };

    desktop.apps = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }: {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
              };

              features = {
                wayland.enable = mkOption {
                  type = types.bool;
                  default = true;
                };
                audio.enable = mkOption {
                  type = types.bool;
                  default = true;
                };
              };

              mounts = {
                ro = mkOption { type = types.listOf types.str; };
                rw = mkOption { type = types.listOf types.str; };
              };

              package = mkOption { type = types.package; };
              extraPackages = mkOption { type = types.listOf types.package; };
              environment = mkOption { type = types.attrsOf types.str; };

              executable = mkOption { type = types.str; };
              extraInit = mkOption {
                type = types.str;
                default = "";
              };
            };
          }
        )
      );
    };
  };

  config = {
    security.sudo.extraRules = attrsets.mapAttrsToList (name: _: {
      users = [ cfg.settings.user.name ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-container start ${name}";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nixos-container run  ${name} -- systemctl start ${name}.service";
          options = [ "NOPASSWD" ];
        }
      ];
    }) cfg.desktop.apps;

    containers = attrsets.mapAttrs (
      name: opts:
      let
        uid = toString cfg.settings.user.uid;
        gid = toString cfg.settings.user.gid;

        HOME = cfg.settings.user.home;
        XDG_RUNTIME_DIR = "/run/user/${uid}";
      in
      {
        autoStart = false;

        bindMounts =
          (optionalAttrs opts.features.wayland.enable {
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
          // (optionalAttrs opts.features.audio.enable {
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

        config =
          { pkgs, ... }:
          {
            imports = [
              ../regions/jp.nix
            ];

            system = {
              inherit (config.system) stateVersion;
            };

            systemd.tmpfiles.rules = [
              "d ${XDG_RUNTIME_DIR} 700 ${uid} ${gid} - -"
              "d ${HOME} 700 ${uid} ${gid} - -"
            ]
            ++ (optionals opts.features.audio.enable [
              "d ${XDG_RUNTIME_DIR}/pulse 700 ${uid} ${gid} - -"
            ]);

            i18n = {
              defaultLocale = "en_US.UTF-8";
              extraLocales = [ "ja_JP.UTF-8/UTF-8" ];
            };

            users.users.${cfg.settings.user.name} = {
              enable = true;
              isNormalUser = true;
              inherit (cfg.settings.user) uid group extraGroups;
            };

            users.groups.${cfg.settings.user.group} = {
              inherit (cfg.settings.user) gid;
            };

            programs.dconf.enable = opts.features.wayland.enable;

            fonts = optionalAttrs opts.features.wayland.enable {
              inherit (config.fonts) packages;
              fontconfig = {
                inherit (config.fonts.fontconfig) enable defaultFonts;
              };
            };

            environment.systemPackages = [
              opts.package
            ]
            ++ opts.extraPackages
            ++ (optionalAttrs opts.features.wayland.enable (
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
              // cfg.settings.locale
              // (optionalAttrs opts.features.wayland.enable {
                GTK_THEME = "${cfg.settings.theme.gtk}";

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
              // (optionalAttrs cfg.desktop.inputMethod.enable {
                GTK_IM_MODULE = cfg.desktop.inputMethod.type;
                QT_IM_MODULE = cfg.desktop.inputMethod.type;
                XMODIFIER = "@im=${cfg.desktop.inputMethod.type}";
              })
              // opts.environment;

              serviceConfig = {
                Type = "simple";
                User = cfg.settings.user.name;
                Group = cfg.settings.user.group;
                ExecStartPre =
                  pkgs.writeShellScript "pre-start.sh" (
                    optionalString opts.features.wayland.enable ''
                      ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface cursor-size 24
                      ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface cursor-theme capitaine-cursors-white
                      ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface font-name "Sans 9"
                      ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface gtk-theme "Fluent-Light-compact"
                      ${lib.getExe' pkgs.glib "gsettings"} set org.gnome.desktop.interface icon-theme "Fluent-light"
                    ''
                  )
                  + opts.extraInit;
                ExecStart = "${lib.getExe' opts.package opts.executable}";
              };
            };
          };
      }
    ) cfg.desktop.apps;
  };
}
