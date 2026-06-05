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

  # Open WebUI
  services.open-webui = {
    enable = true;
    stateDir = "/persist/home/nyarla/Applications/AI/NixOSUI.Data";
    port = 21080;
    environment = {
      ENABLE_SIGNUP = "False";
      WEBUI_ADMIN_NAME = "nyarla";
      WEBUI_ADMIN_EMAIL = "me@nyarla.jp";
      WEBUI_ADMIN_PASSWORD = "init12345!@#$%";
      DEFAULT_LOCALE = "ja";

      ENABLE_WEB_SEARCH = "True";
      WEB_SEARCH_ENGINE = "duckduckgo";
    };
  };

  systemd.services.open-webui.serviceConfig = {
    DynamicUser = lib.mkForce false;
    PrivateUSer = lib.mkForce false;
    User = "nyarla";
    Group = "users";
  };

  services.nginx.virtualHosts."llm.services.thotep.net" = {
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
      proxyPass = "http://127.0.0.1:21080";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };

  services.nginx.virtualHosts."comfyui.services.thotep.net" = {
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
      proxyPass = "http://127.0.0.1:8188";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
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
