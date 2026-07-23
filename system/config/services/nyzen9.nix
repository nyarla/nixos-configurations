{ lib, pkgs, ... }:
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

  # hister
  services.hister = {
    enable = true;
    dataDir = "/var/lib/hister";
    settings = {
      app = {
        search_url = "https://duckduckgo.com/?q={query}";
      };
      server = {
        address = "127.0.0.1:4433";
        base_url = "https://hister.services.thotep.net";
        database = "sqlite3.db";
      };
    };
  };

  services.nginx.virtualHosts."hister.services.thotep.net" = {
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
      proxyPass = "http://127.0.0.1:4433";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };

  # comfyui
  systemd.services.comfyui = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "ComfyUI Server";
    path = with pkgs; [ rocmPackages.rocminfo ];
    serviceConfig = {
      Type = "simple";
      User = "nyarla";
      Group = "users";
      Restart = "on-failure";
      ExecStart =
        let
          args = lib.strings.concatStringsSep " " [
            "--listen=0.0.0.0"
            "--port=8188"

            "--base-directory=/persist/home/nyarla/Applications/AI/ComfyUI.Data"
            "--database-url=sqlite:///persist/home/nyarla/Applications/AI/ComfyUI.Data/sqlite3.db"

            "--preview-method=auto"
            "--reserve-vram=1"
          ];
        in
        "${pkgs.comfyui}/bin/main.py ${args}";
    };
  };

  # llama-swap
  services.llama-swap = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 11343;
    settings =
      let
        rocm = lib.getExe' pkgs.llama-cpp-rocm "llama-server";
        DIR = "/persist/home/nyarla/Applications/AI/Llama.Data";

        gemma4 = {
          cmd = "${rocm} --port \${PORT} --temp 1.0 --top-p 0.9 --top-k 64 --jinja";
          env = [
            "LLAMA_ARG_CTX_SIZE=${toString (1024 * 16)}"
            "LLAMA_ARG_FLASH_ATTN=on"
            "LLAMA_ARG_FIT=on"
            "LLAMA_ARG_N_PARALLEL=1"

            "LLAMA_ARG_DEVICE=ROCm0"
          ];
          capabilities = {
            "in" = [
              "text"
              "image"
              "audio"
            ];
            "out" = [ "text" ];
            tools = true;
            context = toString (1024 * 16);
          };
        };
      in
      {
        models = {
          "gemma4-e4b-q8_0" = {
            name = "Gemma 4 E4B (Q8_0)";
            inherit (gemma4) cmd capabilities;
            env = gemma4.env ++ [
              "LLAMA_ARG_MODEL=${DIR}/Gemma-4-E4B-it-Q8_0.gguf"
              "LLAMA_ARG_MMPROJ=${DIR}/mmproj-Gemma-4-f16.gguf"
            ];
          };

          "gemma4-e4b-uncensored-q4_k_m" = {
            name = "Gemma 4 E4b Uncensored (Q4_K_M)";
            inherit (gemma4) cmd capabilities;
            env = gemma4.env ++ [
              "LLAMA_ARG_MODEL=${DIR}/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-Q4_K_M.gguf"
              "LLAMA_ARG_MMPROJ=${DIR}/mmproj-Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-f16.gguf"
            ];
          };

          "gemma4-e4b-uncensored-q8_k_p" = {
            name = "Gemma 4 E4b Uncensored (Q8_K_P)";
            inherit (gemma4) cmd capabilities;
            env = gemma4.env ++ [
              "LLAMA_ARG_MODEL=${DIR}/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-Q8_K_P.gguf"
              "LLAMA_ARG_MMPROJ=${DIR}/mmproj-Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-f16.gguf"
            ];
          };
        };
      };
  };
  systemd.services.llama-swap.path = with pkgs; [ rocmPackages.rocm-smi ];
  systemd.services.llama-swap.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "nyarla";
    Group = "users";
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
