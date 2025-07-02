{
  pkgs,
  config,
  lib,
  ...
}:
{
  # Librechat by podman compose
  systemd.user.services.librechat = {
    enable = true;
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "forking";
      RemainAfterExit = "yes";
      WorkingDirectory = "/home/nyarla/Applications/AI/Librechat";
      ExecStart = toString (
        pkgs.writeShellScript "librechat-start" ''
          export PATH=${
            lib.makeBinPath [
              config.virtualisation.podman.package
              pkgs.podman-compose
            ]
          }:/run/wrappers/bin:$PATH
          export XDG_RUNTIME_DIR=/run/user/$(id -u)

          env DBUS_SESSION_BUS_ADDRESS= podman compose up -d
        ''
      );

      ExecStop = toString (
        pkgs.writeShellScript "librechat-stop" ''
          export PATH=${
            lib.makeBinPath [
              config.virtualisation.podman.package
              pkgs.podman-compose
            ]
          }:/run/wrappers/bin:$PATH
          export XDG_RUNTIME_DIR=/run/user/$(id -u)

          env DBUS_SESSION_BUS_ADDRESS= podman compose down
        ''
      );
    };
  };

  services.ollama = {
    enable = true;
    user = "ollama";
    group = "ollama";
  };

  # for FreshRSS
  services.flaresolverr.enable = true;

  # calibre
  systemd.services.calibre-web.after = [ "automount-encrypted-usb-device.service" ];
  services.calibre-web = {
    enable = true;
    user = "nyarla";
    group = "users";
    listen = {
      ip = "127.0.0.1";
      port = 40001;
    };
    options = {
      calibreLibrary = "/persist/data/14887bd8-3e3c-4675-9e81-9027a050cdf7/Calibre";
    };
  };

  # httpd
  security.acme = {
    acceptTerms = true;
    defaults = {
      enableDebugLogs = false;
      email = "nyarla@kalaclista.com";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      environmentFile = "/persist/var/lib/acme/cloudflare";
    };

    certs."localhost.thotep.net" = {
      extraDomainNames = [
        "*.localhost.thotep.net"
        "*.p.localhost.thotep.net"
        "*.f.localhost.thotep.net"
      ];
    };
  };

  systemd.services.caddy.serviceConfig.ExecStartPre = toString (
    pkgs.writeShellScript "wait.sh" ''
      while [[ -z "$(${pkgs.tailscale}/bin/tailscale ip | head -n1)" ]]; do
        sleep 1
      done
    ''
  );
  services.caddy = {
    enable = true;
    virtualHosts = {
      # for private web services
      "ebooks.p.localhost.thotep.net" = {
        listenAddresses = [ "100.103.65.77" ];
        useACMEHost = "localhost.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 127.0.0.1:40001
        '';
      };
      "librechat.p.localhost.thotep.net" = {
        listenAddresses = [ "100.103.65.77" ];
        useACMEHost = "localhost.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 127.0.0.1:40010
        '';
      };

      # for development
      "gts.f.localhost.thotep.net" = {
        listenAddresses = [ "100.103.65.77" ];
        useACMEHost = "localhost.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 127.0.0.1:50000
        '';
      };

      "masto.f.localhost.thotep.net" = {
        listenAddresses = [ "100.103.65.77" ];
        useACMEHost = "localhost.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          handle /api/v1/streaming* {
            reverse_proxy 127.0.0.1:50021
          }

          handle {
            reverse_proxy 127.0.0.1:50020
          }
        '';
      };

      "misskey.f.localhost.thotep.net" = {
        listenAddresses = [ "100.103.65.77" ];
        useACMEHost = "localhost.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 127.0.0.1:50030
        '';
      };
    };
  };
}
