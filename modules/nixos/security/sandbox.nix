{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.mod.security.sandbox;
  desktopCfg = cfg.desktop;
  shellCfg = cfg.shell;
in
{
  options.mod.security.sandbox = {
    settings = {
      user = {
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
      locale = mkOption {
        type = types.attrsOf types.str;
        default = {
          LANG = "en_US.UTF-8";
          LC_ALL = "en_US.UTF-8";
        };
      };
      theme = {
        gtk = mkOption { type = types.str; };
      };
    };

    desktop = {
      inputMethod = {
        enable = mkOption {
          type = types.bool;
          default = config.i18n.inputMethod.enable;
        };

        type = mkOption {
          type = types.str;
          default = config.i18n.inputMethod.type;
        };
      };

      apps = mkOption {
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

    shell = {
      settings = {
        dotfiles = mkOption {
          type = types.attrsOf types.str;
          default = { };
        };

        mounts = {
          ro = mkOption { type = types.listOf types.str; };
          rw = mkOption { type = types.listOf types.str; };
        };
      };

      features = {
        gnupg.enable = mkOption {
          type = types.bool;
          default = true;
        };
        neovim.enable = mkOption {
          type = types.bool;
          default = true;
        };
        pi-coding-agent.enable = mkOption {
          type = types.bool;
          default = false;
        };
        desktop.enable = mkOption {
          type = types.bool;
          default = false;
        };
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
      };

      apps = mkOption {
        type = types.attrsOf (
          types.submodule (
            { name, ... }: {
              options = {
                name = mkOption {
                  type = types.str;
                  default = name;
                };

                packages = mkOption {
                  type = types.listOf types.package;
                  default = [ ];
                };

                bind = mkOption {
                  type = types.submodule (
                    { ... }: {
                      options = {
                        ro = mkOption { type = types.listOf types.str; };
                        rw = mkOption { type = types.listOf types.str; };
                      };
                    }
                  );

                  default = {
                    ro = [ ];
                    rw = [ ];
                  };
                };

                ports = mkOption {
                  type = types.listOf types.int;
                  default = [ ];
                };
              };
            }
          )
        );
      };
    };
  };

  config = {
    security.sudo.extraRules =
      (attrsets.mapAttrsToList (name: _: {
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
      }) desktopCfg.apps)
      ++ [
        {
          users = [ cfg.settings.user.name ];
          commands = [
            {
              command = "/run/current-system/sw/bin/nixos-container start shellbox";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];

    containers =
      attrsets.mapAttrs (
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

              mod.regions.jp = true;

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

                  WAYLAND_DISPLAY = "wayland-0";
                })
                // (optionalAttrs desktopCfg.inputMethod.enable {
                  GTK_IM_MODULE = desktopCfg.inputMethod.type;
                  QT_IM_MODULE = desktopCfg.inputMethod.type;
                  XMODIFIER = "@im=${desktopCfg.inputMethod.type}";
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
      ) desktopCfg.apps
      // {
        shellbox =
          let
            name = cfg.settings.user.name;
            group = cfg.settings.user.group;

            uid = toString cfg.settings.user.uid;
            gid = toString cfg.settings.user.gid;

            HOME = cfg.settings.user.home;
            XDG_RUNTIME_DIR = "/run/user/${uid}";
          in
          {
            autoStart = false;

            additionalCapabilities = [
              "CAP_BPF"
              "CAP_NET_ADMIN"
              "CAP_SETGID"
              "CAP_SETUID"
            ];

            privateNetwork = true;
            hostAddress = "192.168.254.10";
            localAddress = "192.168.254.11";

            bindMounts =
              { }
              // (optionalAttrs shellCfg.features.gnupg.enable {
                "${HOME}/.gnupg".isReadOnly = false;
                "${XDG_RUNTIME_DIR}/gnupg".isReadOnly = false;
              })
              // (optionalAttrs shellCfg.features.neovim.enable {
                "${HOME}/.config/nvim".isReadOnly = true;
                "${HOME}/.local/share/nvim".isReadOnly = true;
              })
              // (optionalAttrs shellCfg.features.pi-coding-agent.enable {
                "${HOME}/.pi".isReadOnly = false;
              })
              // (optionalAttrs shellCfg.features.desktop.enable {
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
                "${XDG_RUNTIME_DIR}/pulse/native".isReadOnly = false;
              })
              // mergeAttrsList (
                lists.forEach shellCfg.settings.mounts.ro (path: {
                  "${path}".isReadOnly = true;
                })
              )
              // mergeAttrsList (
                lists.forEach shellCfg.settings.mounts.rw (path: {
                  "${path}".isReadOnly = false;
                })
              )
              // (concatMapAttrs (from: _: {
                "${from}".isReadOnly = true;
              }) shellCfg.settings.dotfiles);

            config = { pkgs, ... }: {
              imports = [
                ../regions/jp.nix
              ];

              system = {
                inherit (config.system) stateVersion;
              };

              mod.regions.jp = true;

              users.users.${cfg.settings.user.name} = {
                enable = true;
                isNormalUser = true;
                inherit (cfg.settings.user) uid group extraGroups;
              };

              users.groups.${cfg.settings.user.group} = {
                inherit (cfg.settings.user) gid;
              };

              systemd.tmpfiles.rules = [
                "d ${HOME} 700 ${uid} ${gid} - -"
                "d ${HOME}/.cache 700 ${uid} ${gid} - -"
                "d ${HOME}/.config 700 ${uid} ${gid} - -"
                "d ${HOME}/.local 700 ${uid} ${gid} - -"
                "d ${HOME}/.local/share 700 ${uid} ${gid} - -"
                "d ${HOME}/.local/state 700 ${uid} ${gid} - -"
                "d ${XDG_RUNTIME_DIR} 700 ${uid} ${gid} - -"
              ];

              boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

              networking.firewall.enable = false;
              networking.firewall.checkReversePath = "loose";

              networking.useHostResolvConf = lib.mkForce false;
              services.resolved.enable = true;

              virtualisation.docker = {
                enable = true;
                autoPrune.enable = true;
              };

              environment.systemPackages =
                let
                  shellbox =
                    name: opts:
                    pkgs.writeShellApplication {
                      name = "shellbox-${name}";
                      runtimeInputs = with pkgs; [ docker ];
                      text = ''
                        set -euo pipefail

                        if [[ -z "''${1:-}" ]]; then
                          echo "Usage: shellbox-${name} <directory>"
                          exit 1
                        fi

                        exec docker run -it --rm --hostname "shellbox-${name}" ${
                          concatMapStrings (port: "-p 192.168.254.11:${toString port}:${toString port}") opts.ports
                        } ${
                          concatStrings [
                            "--mount \"type=bind,dst=/app,src=\${1}\" "
                            "--mount \"type=bind,ro,dst=/app-ro,src=\${1}\" "
                          ]
                        } ${
                          concatMapStrings (p: "--mount type=bind,src=${p},dst=${p} ") (
                            (optionals shellCfg.features.gnupg.enable [
                              "${HOME}/.gnupg"
                              "${XDG_RUNTIME_DIR}/gnupg"
                            ])
                            ++ opts.bind.rw
                          )
                        } ${
                          concatMapStrings (p: "--mount type=bind,ro,src=${p},dst=${p} ") (
                            (optionals shellCfg.features.pi-coding-agent.enable [
                              "${HOME}/.pi/secrets"
                            ])
                            ++ (optionals shellCfg.features.neovim.enable [
                              "${HOME}/.config/nvim"
                              "${HOME}/.local/share/nvim"
                            ])
                            ++ opts.bind.ro
                          )
                        } ${
                          concatStrings (
                            mapAttrsToList (from: to: "--mount type=bind,ro,src=${from},dst=${to} ") shellCfg.settings.dotfiles
                          )
                        } ${
                          concatStrings (
                            mapAttrsToList (from: to: "--mount type=bind,src=${from},dst=${to} ") (
                              (optionalAttrs shellCfg.features.pi-coding-agent.enable {
                                "${HOME}/.pi/env/${name}" = "${HOME}/.pi/agent";
                              })
                            )
                          )
                        } ${name}:latest -c "${concatStringsSep "; " (optional shellCfg.features.gnupg.enable "ln -sf /run/user/1000/gnupg/* ~/.gnupg/")}; herdr"
                      '';
                    };
                in
                mapAttrsToList shellbox shellCfg.apps;

              virtualisation.oci-containers.backend = "docker";
              virtualisation.oci-containers.containers = mapAttrs (name: opts: {
                image = "${name}:latest";
                pull = "never";
                imageFile = pkgs.dockerTools.buildImage {
                  inherit name;
                  tag = "latest";

                  copyToRoot = pkgs.buildEnv {
                    pname = name;
                    version = "latest";
                    paths =
                      with pkgs;
                      [
                        bash
                        coreutils-full
                        findutils
                        gawk
                        gnugrep
                        gnused
                        less
                        ncurses
                        procps
                        which

                        cacert
                        glibcLocales

                        curl
                        dnsutils
                        iputils

                        fence
                        gitFull
                        herdr

                        gh
                        jq
                        ripgrep
                        yq
                      ]
                      ++ shellCfg.extraPackages
                      ++ opts.packages
                      ++ (optionals shellCfg.features.neovim.enable [ neovim ])
                      ++ (optionals shellCfg.features.gnupg.enable [
                        gnupg
                        openssh
                      ])
                      ++ (optionals shellCfg.features.pi-coding-agent.enable [
                        nodejs
                        pi-coding-agent
                        python3
                      ]);

                    pathsToLink = [
                      "/bin"
                      "/etc"
                      "/lib"
                      "/libexec"
                      "/share"
                    ];
                  };

                  runAsRoot = ''
                    ${concatMapStringsSep "\n"
                      (path: ''
                        mkdir -p "${path}"
                        chown -R ${uid}:${gid} "${path}"
                        chmod -R 700 "${path}"
                      '')
                      (
                        [
                          "/app"
                          "/app-ro"

                          HOME
                          (HOME + "/.cache")
                          (HOME + "/.config")
                          (HOME + "/.local/share")
                          (HOME + "/.local/state")

                          XDG_RUNTIME_DIR
                        ]
                        ++ (optionals shellCfg.features.gnupg.enable [ (XDG_RUNTIME_DIR + "/gnupg") ])
                        ++ (optionals shellCfg.features.neovim.enable [
                          (HOME + "/.config/nvim")
                          (HOME + "/.local/share/nvim")
                          (HOME + "/.local/state/nvim")
                        ])
                        ++ (optionals shellCfg.features.pi-coding-agent.enable [ (HOME + "/.pi") ])
                      )
                    }

                    ${concatMapStringsSep "\n" (path: ''
                      mkdir -p "$(dirname "${path}")"
                      chown -R ${uid}:${gid} "$(dirname "${path}")"
                      chmod -R 700 "$(dirname "${path}")"
                    '') (mapAttrsToList (_: to: to) shellCfg.settings.dotfiles)}

                    mkdir -p /usr/bin
                    ln -sf /bin/env /usr/bin/env

                    mkdir -p /tmp
                    chmod -R 777 /tmp

                    mkdir -p /etc
                    chmod -R 755 /etc

                    cat <<... > /etc/shadow
                    root:!x:::::::
                    ${name}:!x:::::::
                    ...

                    cat <<... > /etc/passwd
                    root:x:0:0::/root:/bin/sh
                    ${name}:x:${uid}:${gid}::${HOME}:/bin/zsh
                    ...

                    cat <<... > /etc/group
                    root:x:0:
                    ${group}:x:${gid}
                    ...

                    cat <<... > /etc/gshadow
                    root:x::
                    ${name}:x::
                    ...
                  '';

                  config = {
                    Entrypoint = [ "bash" ];
                    Cmd = [ "--login" ];

                    Env = [
                      "LANG=en_US.UTF-8"
                      "LC_ALL=en_US.UTF-8"
                      "LOCALE_ARCHIVE=/lib/locale/locale-archive"
                      "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
                    ]
                    ++ (optionals shellCfg.features.gnupg.enable [
                      "SSH_AUTH_SOCK=${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
                    ]);

                    User = "${uid}:${gid}";

                    WorkingDir = "/app";
                  };
                };
              }) shellCfg.apps;
            };
          };
      };
  };
}
