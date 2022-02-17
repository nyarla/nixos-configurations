{ pkgs, lib, config, ... }: {
  # TT-RSS
  services.tt-rss = {
    enable = true;
    virtualHost = "reader.home.thotep.net";
    selfUrlPath = "https://reader.home.thotep.net";
    database.passwordFile = "/etc/home-hosted/tt-rss/dbpassword";
    auth.autoLogin = false;
    themePackages = with pkgs; [ tt-rss-theme-feedly ];
  };

  # nitter
  services.nitter = {
    enable = true;
    server = {
      address = "127.0.0.1";
      port = 8079;
      hostname = "nitter.home.thotep.net";
    };
    config = { tokenCount = 1; };
  };

  services.n8n = {
    enable = true;
    settings = { generic = { timezone = "Asia/Tokyo"; }; };
  };

  # nginx
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "nyarla@kalaclista.com";
      reloadServices = [ "nginx" ];
      renewInterval = "2weeks";
    };
    certs."home.thotep.net" = {
      server = "https://acme-v02.api.letsencrypt.org/directory";
      credentialsFile = "/etc/home-hosted/acme/cloudflare";
      dnsPropagationCheck = true;
      dnsProvider = "cloudflare";
      domain = "home.thotep.net";
      extraDomainNames = [ "*.home.thotep.net" ];
      group = "nginx";
    };
  };

  services.nginx.virtualHosts = {
    "nitter.home.thotep.net" = {
      onlySSL = true;
      sslCertificate = "/var/lib/acme/home.thotep.net/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home.thotep.net/key.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:8079";
        proxyWebsockets = true;
      };
    };
    "n8n.home.thotep.net" = {
      onlySSL = true;
      sslCertificate = "/var/lib/acme/home.thotep.net/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home.thotep.net/key.pem";
      locations."/" = {
        proxyPass = "http://127.0.0.1:5678";
        proxyWebsockets = true;
      };
    };
    "reader.home.thotep.net" = {
      onlySSL = true;
      sslCertificate = "/var/lib/acme/home.thotep.net/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home.thotep.net/key.pem";
      locations."/".proxyWebsockets = true;
    };
  };

}
