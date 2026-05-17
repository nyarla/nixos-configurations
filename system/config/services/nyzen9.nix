{ lib, ... }:
{
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

    certs."services.thotep.net" = {
      extraDomainNames = [
        "*.services.thotep.net"
        "*.fedi.thotep.net"
      ];
    };
  };

  # FreshRSS for localhost
  services.freshrss = {
    enable = true;
    baseUrl = "https://freshrss.services.thotep.net";
    virtualHost = "freshrss.services.thotep.net";

    defaultUser = "nyarla";
    passwordFile = "/var/lib/freshrss/password";

    language = "ja";
  };
  services.nginx.virtualHosts."freshrss.services.thotep.net" = {
    useACMEHost = "services.thotep.net";
    forceSSL = true;
    listen =
      let
        addr = "100.103.65.77";
      in
      lib.mkForce [
        {
          inherit addr;
          port = 80;
          ssl = false;
        }
        {
          inherit addr;
          port = 443;
          ssl = true;
        }
      ];
  };

  # nginx frontend
  users.users.nginx.extraGroups = [ "acme" ];
  services.nginx.enable = true;
  services.nginx.virtualHosts."*.fedi.thotep.net" = {
    useACMEHost = "services.thotep.net";
    forceSSL = true;
    listen =
      let
        addr = "100.103.65.77";
      in
      [
        {
          inherit addr;
          port = 80;
          ssl = false;
        }
        {
          inherit addr;
          port = 443;
          ssl = true;
        }
      ];
    locations."/" = {
      proxyPass = "http://127.0.0.1:21515";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
