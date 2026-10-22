{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.security.shellbox;
in
{
  options.my.security.shellbox = {
    enable = mkEnableOption "secure shellbox";

    bind = {
      ro = mkOption { type = types.listOf types.str; };
      rw = mkOption { type = types.listOf types.str; };
    };

    user = {
      user = mkOption { type = types.str; };
      group = mkOption { type = types.str; };
      uid = mkOption { type = types.int; };
      gid = mkOption { type = types.int; };
    };

    programs = {
      gnupg.enable = mkEnableOption "gnupg support";
      neovim.enable = mkEnableOption "nvim support";
      pi-coding-agent.enable = mkEnableOption "pi coding agent";
      proton-pass-cli.enable = mkEnableOption "proton-pass-cli support";
    };

    dotfiles = {
      enable = mkEnableOption "dotfiles support";
      files = mkOption {
        type = types.attrsOf types.str;
        default = { };
      };
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
    };

    shells = mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }: {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
              };

              tag = mkOption {
                type = types.str;
              };

              packages = mkOption {
                type = types.listOf types.package;
                default = [ ];
              };

              mounts = mkOption {
                type = types.listOf types.str;
                default = [ ];
              };

              ports = mkOption {
                type = types.listOf types.int;
                default = [ ];
              };
            };
          }
        )
      );

      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    security.sudo.extraRules = [
      {
        users = [ cfg.user.user ];
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-container start shellbox";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    containers."shellbox" = {
      autoStart = false;
      restartIfChanged = false;

      bindMounts =
        { }
        // (optionalAttrs cfg.programs.neovim.enable {
          "/home/${cfg.user.user}/.config/nvim".isReadOnly = true;
          "/home/${cfg.user.user}/.local/share/nvim".isReadOnly = true;
        })
        // (optionalAttrs cfg.programs.gnupg.enable {
          "/home/${cfg.user.user}/.gnupg".isReadOnly = false;
          "/run/user/${toString cfg.user.uid}/gnupg".isReadOnly = false;
        })
        // (optionalAttrs cfg.programs.pi-coding-agent.enable {
          "/home/${cfg.user.user}/.pi".isReadOnly = false;
        })
        // (optionalAttrs cfg.programs.proton-pass-cli.enable {
          "/home/${cfg.user.user}/.local/share/proton-pass-cli".isReadOnly = false;
        })
        // (optionalAttrs cfg.dotfiles.enable (
          attrsets.concatMapAttrs (from: _: { "${from}".isReadOnly = true; }) cfg.dotfiles.files
        ))
        // attrsets.mergeAttrsList (
          lists.forEach cfg.bind.ro (path: {
            "${path}".isReadOnly = true;
          })
        )
        // attrsets.mergeAttrsList (
          lists.forEach cfg.bind.rw (path: {
            "${path}".isReadOnly = false;
          })
        );

      additionalCapabilities = [
        "CAP_BPF"
        "CAP_NET_ADMIN"
        "CAP_SETGID"
        "CAP_SETUID"
      ];

      privateNetwork = true;
      hostAddress = "192.168.254.10";
      localAddress = "192.168.254.11";

      config = { ... }: {
        # NixOS
        boot.isContainer = true;
        system = {
          inherit (config.system) stateVersion;
        };

        # locale
        i18n = {
          defaultLocale = "en_US.UTF-8";
          extraLocales = [ "ja_JP.UTF-8/UTF-8" ];
        };

        # timezone
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
        users.users.${cfg.user.user} = {
          enable = true;
          isNormalUser = true;
          inherit (cfg.user) uid;
          group = cfg.user.group;
          extraGroups = cfg.user.extraGroups or [ ];
        };

        users.groups.${cfg.user.group} = {
          inherit (cfg.user) gid;
        };

        # directories
        systemd.tmpfiles.rules =
          let
            inherit (cfg.user) user group;

            uid = toString cfg.user.uid;

            HOME = "/home/${user}";
          in
          [
            "d /run/user/${uid} 700 ${user} ${group} - -"
            "d ${HOME} 700 ${user} ${group} - -"
            "d ${HOME}/.config 700 ${user} ${group} - -"
            "d ${HOME}/.local 700 ${user} ${group} - -"
            "d ${HOME}/.local/share 700 ${user} ${group} - -"
          ];

        # network
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

                  if [[ -z "''${1}" ]]; then
                    echo "Usage: shellbox-${name} <directory>"
                    exit 1
                  fi

                  exec docker run -it --rm --hostname "shellbox-${name}" ${
                    lib.concatMapStrings (port: "-p 192.168.254.11:${toString port}:${toString port} ") opts.ports
                  } -v "''${1}:/app" ${lib.concatMapStrings (mount: "-v ${mount} ") opts.mounts} ${
                    optionalString cfg.programs.neovim.enable (
                      lib.concatMapStrings (p: "--mount type=bind,ro,src=${p},dst=${p} ") [
                        "/home/${cfg.user.user}/.config/nvim"
                        "/home/${cfg.user.user}/.local/share/nvim"
                      ]
                    )
                  } ${
                    optionalString cfg.programs.gnupg.enable (
                      lib.concatMapStrings (p: "--mount type=bind,src=${p},dst=${p} ") [
                        "/home/${cfg.user.user}/.gnupg"
                        "/run/user/${toString cfg.user.uid}/gnupg"
                      ]
                    )
                  } ${
                    optionalString cfg.programs.proton-pass-cli.enable (
                      lib.concatMapStrings (p: "--mount type=bind,src=${p},dst=${p} ") [
                        "/home/${cfg.user.user}/.local/share/proton-pass-cli"
                      ]
                    )
                  } ${
                    optionalString cfg.programs.pi-coding-agent.enable (
                      lib.concatMapStrings (p: "--mount type=bind,src=${p},dst=${p} ") [
                        "/home/${cfg.user.user}/.pi"
                      ]
                    )
                  } ${
                    optionalString cfg.dotfiles.enable (
                      concatStringsSep " " (
                        lib.mapAttrsToList (from: to: "--mount type=bind,ro,src=${from},dst=${to} ") cfg.dotfiles.files
                      )
                    )
                  } ${name}:${opts.tag} -c "${optionalString cfg.programs.gnupg.enable "ln -sf /run/user/1000/gnupg/S.* ~/.gnupg/; "} herdr";
                '';
              };
          in
          lib.mapAttrsToList shellbox cfg.shells;

        virtualisation.oci-containers.backend = "docker";
        virtualisation.oci-containers.containers = attrsets.mapAttrs (name: opts: {
          image = "${name}:${opts.tag}";
          pull = "never";
          imageFile = pkgs.dockerTools.buildImage {
            inherit name;
            inherit (opts) tag;

            copyToRoot = pkgs.buildEnv {
              pname = name;
              version = opts.tag;
              paths =
                (with pkgs; [
                  bash
                  cacert
                  coreutils-full
                  curl
                  findutils
                  gawk
                  glibcLocales
                  gnugrep
                  gnused
                  iputils
                  less
                  ncurses
                  procps
                  which

                  fence
                  gitFull
                  herdr
                ])
                ++ cfg.extraPackages
                ++ opts.packages
                ++ (optionals cfg.programs.neovim.enable [ pkgs.neovim ])
                ++ (optionals cfg.programs.gnupg.enable (
                  with pkgs;
                  [
                    gnupg
                    openssh
                  ]
                ))
                ++ (optionals cfg.programs.pi-coding-agent.enable (
                  with pkgs;
                  [
                    pi-coding-agent
                    python
                  ]
                ))
                ++ (optionals cfg.programs.proton-pass-cli.enable [ pkgs.proton-pass-cli ]);

              pathsToLink = [
                "/bin"
                "/etc"
                "/lib"
                "/libexec"
                "/share"
              ];
            };

            runAsRoot =
              let
                HOME = "/home/${cfg.user.user}";

                inherit (cfg.user) user;

                uid = toString cfg.user.uid;
                gid = toString cfg.user.gid;
              in
              ''
                ${concatMapStringsSep "\n"
                  (path: ''
                    mkdir -p "${path}"
                    chown -R ${uid}:${gid} "${path}"
                    chmod -R 700 "${path}"
                  '')
                  (
                    [
                      "/app"

                      "${HOME}"
                      "${HOME}/.cache"
                      "${HOME}/.config"
                      "${HOME}/.local/share"
                      "${HOME}/.local/state"

                      "/run/user/${uid}"
                    ]
                    ++ (optionals cfg.programs.gnupg.enable [ "/run/user/${uid}/gnupg" ])
                    ++ (optionals cfg.programs.neovim.enable [
                      "/home/${uid}/.config/nvim"
                      "/home/${uid}/.local/share/nvim"
                    ])
                    ++ (optionals cfg.programs.pi-coding-agent.enable [ "${HOME}/.pi" ])
                    ++ (optionals cfg.programs.proton-pass-cli.enable [ "${HOME}/.local/share/proton-pass-cli" ])
                  )
                }

                ${optionalString cfg.dotfiles.enable (
                  concatStringsSep "\n" (
                    mapAttrsToList (_: to: ''
                      mkdir -p $(dirname "${to}")
                      chown -R ${uid}:${gid} $(dirname "${to}")
                      chmod -R 700 $(dirname "${to}")
                    '') cfg.dotfiles.files
                  )
                )}

                mkdir -p /usr/bin
                ln -sf /bin/env /usr/bin/env

                mkdir -p /tmp
                chmod -R 777 /tmp

                mkdir -p /etc
                chmod -R 755 /etc

                cat <<... > /etc/shadow
                root:!x:::::::
                ${user}:!x:::::::
                ...

                cat <<... > /etc/passwd
                root:x:0:0::/root:/bin/sh
                ${user}:x:${uid}:${gid}::${HOME}:/bin/zsh
                ...

                cat <<... > /etc/group
                root:x:0:
                users:x:${gid}
                ...

                cat <<... > /etc/gshadow
                root:x::
                ${user}:x::
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
              ++ (optionals cfg.programs.gnupg.enable [
                "SSH_AUTH_SOCK=/run/user/${toString cfg.user.uid}/gnupg/S.gpg-agent.ssh"
              ]);

              User =
                let
                  uid = toString cfg.user.uid;
                  gid = toString cfg.user.gid;
                in
                "${uid}:${gid}";

              WorkingDir = "/app";
            };
          };
        }) cfg.shells;
      };
    };
  };
}
