{ pkgs, ... }:
{
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

  services.goatcounter = {
    enable = true;
    port = 40081;
    address = "127.0.0.1";
    proxy = true;
    extraArgs = [
      "-db=sqlite+/var/lib/goatcounter/sqlite.db"
    ];
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "web.p.localhost.thotep.net" = {
        listenAddresses = [ "100.103.65.77" ];
        useACMEHost = "localhost.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 127.0.0.1:40081
        '';
      };

      "search.p.localhost.thotep.net" = {
        listenAddresses = [ "100.103.65.77" ];
        useACMEHost = "localhost.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 127.0.0.1:40081
        '';
      };

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