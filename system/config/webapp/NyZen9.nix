{ pkgs, lib, config, ... }: {
  # mysql
  services.mysql.settings = {
    mysqld = { character-set-server = "utf8mb4"; };
    client = { default-character-set = "utf8mb4"; };
  };

  # postgresql
  services.postgresql.enable = true;

  # TT-RSS
  services.tt-rss = {
    enable = true;
    virtualHost = "reader.home.thotep.net";
    selfUrlPath = "https://reader.home.thotep.net";
    database.passwordFile = "/etc/home-hosted/tt-rss/dbpassword";
    database.type = "pgsql";
    database.createLocally = true;
    auth.autoLogin = false;
    themePackages = with pkgs; [ tt-rss-theme-feedly ];
  };
  services.phpfpm.phpPackage = pkgs.php80;

  services.n8n = {
    enable = true;
    settings = {
      executions = { saveDataOnSuccess = "none"; };
      generic = { timezone = "Asia/Tokyo"; };
    };
  };
  systemd.services.n8n.environment = { DB_SQLITE_VACUUM_ON_STARTUP = "true"; };

  # nginx
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "nyarla@kalaclista.com";
      reloadServices = [ "nginx" ];
      renewInterval = "*-*-14,28 00:00:00";
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
