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
    database.passwordFile = "/var/lib/tt-rss/tt-rss-db-password";
    database.type = "pgsql";
    database.createLocally = true;
    auth.autoLogin = false;
    themePackages = with pkgs; [ tt-rss-theme-feedly ];
  };
  services.phpfpm.phpPackage = pkgs.php80;

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
      credentialsFile = "/var/lib/acme/cloudflare";
      dnsPropagationCheck = true;
      dnsProvider = "cloudflare";
      domain = "home.thotep.net";
      extraDomainNames = [ "*.home.thotep.net" ];
      group = "nginx";
    };
  };

  services.nginx.virtualHosts = {
    "reader.home.thotep.net" = {
      listen = [{
        addr = "100.103.65.77";
        port = 443;
        ssl = true;
      }];
      addSSL = true;
      sslCertificate = "/var/lib/acme/home.thotep.net/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/home.thotep.net/key.pem";
      locations."/".proxyWebsockets = true;
    };
  };

}
