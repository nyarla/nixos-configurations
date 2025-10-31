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
    host = "0.0.0.0";
    openFirewall = true;
  };

  # for FreshRSS
  services.flaresolverr.enable = true;

  # calibre
  systemd.services.calibre-web.after = [ "automount-encrypted-usb-device.service" ];
  systemd.services.calibre-web.environment.CACHE_DIR = lib.mkForce "/home/nyarla/.cache/calibre-web";
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

  # FreshRSS on local machine
  services.freshrss = {
    enable = true;
    baseUrl = "https://freshrss.p.localhost.thotep.net";
    virtualHost = "freshrss.p.localhost.thotep.net";

    defaultUser = "nyarla";
    passwordFile = "/var/lib/freshrss/password";

    language = "ja";
    webserver = "caddy";
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
    virtualHosts =
      let
        devhost = domain: {
          "${domain}" = {
            listenAddresses = [ "100.103.65.77" ];
            useACMEHost = "localhost.thotep.net";
            logFormat = ''
              output stdout
            '';
            extraConfig = ''
              reverse_proxy 127.0.0.1:21515
            '';
          };
        };

        devhosts = domains: lib.attrsets.mergeAttrsList (lib.lists.forEach domains devhost);
      in
      {
        # for private web services
        "calibre.p.localhost.thotep.net" = {
          listenAddresses = [ "100.103.65.77" ];
          useACMEHost = "localhost.thotep.net";
          logFormat = ''
            output stdout
          '';
          extraConfig = ''
            reverse_proxy 127.0.0.1:8085
          '';
        };
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
        "contents.p.localhost.thotep.net" = {
          listenAddresses = [ "100.103.65.77" ];
          useACMEHost = "localhost.thotep.net";
          logFormat = ''
            output stdout
          '';
          extraConfig = ''
            reverse_proxy 127.0.0.1:40020
          '';
        };

        "freshrss.p.localhost.thotep.net" = {
          listenAddresses = [ "100.103.65.77" ];
          useACMEHost = "localhost.thotep.net";
          logFormat = ''
            output stdout
          '';
        };
      }
      // devhosts [
        "gts.f.localhost.thotep.net"
        "misskey.f.localhost.thotep.net"
        "mstdn.f.localhost.thotep.net"
      ];
  };
}
