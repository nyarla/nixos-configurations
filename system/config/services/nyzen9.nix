{
  pkgs,
  config,
  lib,
  ...
}:
{
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
