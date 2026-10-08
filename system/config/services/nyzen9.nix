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

  # bookwall
  systemd.services.bookwall = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "Bookwall eBooks server";
    path = with pkgs; [
      sqlite
      ruby_4_0
    ];

    environment = rec {
      BOOKWALL_DATA_DIR = "/persist/home/nyarla/Applications/Data/Bookwall";
      DISABLE_DATABASE_ENVIRONMENT_CHECK = "1";
      HTTP_PORT = "8237";
      TARGET_PORT = "38080";
      HTTP_WRITE_TIMEOUT = "0";
      RAILS_ENV = "production";
      SCHEMA_FORMAT = "ruby";
      SECRET_KEY_FILE = "${BOOKWALL_DATA_DIR}/secret_key_file";
      RAILS_SERVE_STATIC_FILES = "true";
    };

    serviceConfig = {
      Type = "simple";
      User = "nyarla";
      Group = "users";
      WorkingDirectory = "/persist/home/nyarla/Applications/Data/Bookwall";
      ExecStartPre = toString (
        pkgs.writeShellScript "bootstrap" ''
          test -d rails || mkdir -p rails

          cp -r ${pkgs.bookwall}/* rails/
          chmod -R +w rails/
          chmod +x rails/bin/*

          if [[ ! -f "''${SECRET_KEY_FILE}" ]]; then
            mkdir -p "$(dirname "''${SECRET_KEY_FILE}")"
            ruby -rsecurerandom -e 'puts SecureRandom.hex(64)' > "''${SECRET_KEY_FILE}"
            chmod 600 "''${SECRET_KEY_FILE}"
          fi

          export SECRET_KEY_BASE="$(cat "''${SECRET_KEY_FILE}")"

          cd rails || exit 1

          ./bin/rails db:prepare
          ./bin/rails db:schema:load:queue
          ./bin/rails db:schema:load:cache
        ''
      );
      ExecStart = toString (
        pkgs.writeShellScript "launch" ''
          export SECRET_KEY_BASE="$(cat "''${SECRET_KEY_FILE}")"

          cd rails || exit 1
          ./bin/thrust ${pkgs.bookwall}/bin/bundle exec falcon serve --bind http://127.0.0.1:38080 --count 4 &
          appPID=$!

          ./bin/jobs &
          jobsPID=$!

          wait $appPID
          kill $jobsPID
        ''
      );
    };
  };
  services.nginx.virtualHosts."bookwall.services.thotep.net" = {
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

    root = "/persist/home/nyarla/Applications/Data/Bookwall/rails/public";
    locations = {
      "/" = {
        tryFiles = "$uri $uri/index.html $uri/ @rails";
      };
      "@rails" = {
        priority = 500;
        proxyWebsockets = true;
        proxyPass = "http://127.0.0.1:8237";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
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
    environment = {
      HOME = "/persist/home/nyarla/Applications/AI/ComfyUI.Home";
      TORCH_ROCM_AOTRITON_ENABLE_EXPERIMENTAL = "1";
      MIOPEN_FIND_MODE = "FAST";
      TORCHINDUCTOR_CACHE_DIR = "/persist/home/nyarla/Applications/AI/ComfyUI.Data/cache/inductor_cache";
    };
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

            "--use-quad-cross-attention"

            "--disable-smart-memory"
            "--disable-dynamic-vram"
            "--bf16-vae"
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
        llm-jp = lib.getExe' pkgs.llama-cpp-llm-jp "llama-server";
        DIR = "/persist/home/nyarla/Applications/AI/Llama.Data";

        gemma4 = {
          cmd = "${rocm} --port \${PORT} --temp 1.0 --top-p 0.9 --top-k 64 --jinja --cpu-moe";
          env = [
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
            context = 1024 * 32;
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
            name = "Gemma 4 E4B Uncensored (Q4_K_M)";
            inherit (gemma4) cmd capabilities;
            env = gemma4.env ++ [
              "LLAMA_ARG_MODEL=${DIR}/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-Q4_K_M.gguf"
              "LLAMA_ARG_MMPROJ=${DIR}/mmproj-Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-f16.gguf"
            ];
          };

          "gemma4-e4b-uncensored-q8_k_p" = {
            name = "Gemma 4 E4B Uncensored (Q8_K_P)";
            inherit (gemma4) cmd capabilities;
            env = gemma4.env ++ [
              "LLAMA_ARG_MODEL=${DIR}/Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-Q8_K_P.gguf"
              "LLAMA_ARG_MMPROJ=${DIR}/mmproj-Gemma-4-E4B-Uncensored-HauhauCS-Aggressive-f16.gguf"
            ];
          };

          "lfm2.5-1.2b-jp_q8_0" = {
            name = "LFM2.5 1.2B JP (Q8_0)";
            cmd = "${rocm} --port \${PORT} --temp 0.3 --min-p 0.15 --repeat-penalty 1.05 --jinja";
            capabilities = {
              "in" = [ "text" ];
              "out" = [ "text" ];
              tools = true;
              context = 1024 * 32;
            };
            env = [
              "LLAMA_ARG_MODEL=${DIR}/LFM2.5-1.2B-JP-202606-Q8_0.gguf"
              "LLAMA_ARG_FLASH_ATTN=on"
              "LLAMA_ARG_FIT=on"
              "LLAMA_ARG_N_PARALLEL=1"
              "LLAMA_ARG_DEVICE=ROCm0"
            ];
          };

          "lfm2.5-8b-a1b_q8_0" = {
            name = "LFM2.5 8B A1B (Q8_0)";
            cmd = "${rocm} --port \${PORT} --temp 0.2 --top-k 80 --repeat-penalty 1.05 --jinja";
            capabilities = {
              "in" = [ "text" ];
              "out" = [ "text" ];
              tools = true;
              context = 1024 * 32;
            };
            env = [
              "LLAMA_ARG_MODEL=${DIR}/LFM2.5-8B-A1B-Q8_0.gguf"
              "LLAMA_ARG_FLASH_ATTN=on"
              "LLAMA_ARG_FIT=on"
              "LLAMA_ARG_N_PARALLEL=1"
              "LLAMA_ARG_DEVICE=ROCm0"
            ];
          };

          "qwen3-coder-next_UD-q4_k_xl" = {
            name = "Qwen3 Coder Next (UD Q4_K_XL)";
            cmd = "${rocm} --port \${PORT} -fa on --temp 1.0 --top-p 0.95 --top-k 40 --min-p 0.01 --jinja --cpu-moe --repeat-penalty 1.10";
            capabilities = {
              "in" = [ "text" ];
              "out" = [ "text" ];
              tools = true;
              context = 1024 * 256;
            };
            env = [
              "LLAMA_ARG_MODEL=${DIR}/Qwen3-Coder-Next-UD-Q4_K_XL.gguf"
              "LLAMA_ARG_FLASH_ATTN=on"
              "LLAMA_ARG_DEVICE=ROCm0"
            ];
          };

          "ornith-1.5-35b_q4_k_m" = {
            name = "Ornith 1.5 35B (Q4_K_M)";
            cmd = "${rocm} --port \${PORT} -fa on --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.0 --presence-penalty 1.5 --repeat-penalty 1.0 --jinja --cpu-moe";
            capabilities = {
              "in" = [ "text" ];
              "out" = [ "text" ];
              tools = true;
              context = 1024 * 256;
            };
            env = [
              "LLAMA_ARG_MODEL=${DIR}/Ornith-1.5-35B-Q4_K_M.gguf"
              "LLAMA_ARG_MMPROJ=${DIR}/mmproj-Ornith-1.5-35B-BF16.gguf"
              "LLAMA_ARG_DEVICE=ROCm0"
            ];
          };

          "ornith-1.5-35b-pro_q4_k_m" = {
            name = "Ornith 1.5 35B (Pro) (Q4_K_M)";
            cmd = "${rocm} --port \${PORT} -fa on --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0 --presence-penalty 0.0 --repeat-penalty 1.0 --jinja --cpu-moe";
            capabilities = {
              "in" = [ "text" ];
              "out" = [ "text" ];
              tools = true;
              context = 1024 * 256;
            };
            env = [
              "LLAMA_ARG_MODEL=${DIR}/Ornith-1.5-35B-Q4_K_M.gguf"
              "LLAMA_ARG_MMPROJ=${DIR}/mmproj-Ornith-1.5-35B-BF16.gguf"
              "LLAMA_ARG_DEVICE=ROCm0"
            ];
          };

          "llm-jp-4-32b-a3b-thinking_q4_k_m" = {
            name = "llm-jp 4 32B A3B Thinking (Q4_K_M)";
            cmd = "${llm-jp} --port \${PORT} -fa on --jinja --cpu-moe";
            capabilities = {
              "in" = [ "text" ];
              "out" = [ "text" ];
              tools = true;
              context = 1024 * 256;
            };
            env = [
              "LLAMA_ARG_MODEL=${DIR}/llm-jp-4-32b-a3b-thinking-Q4_K_M.gguf"
              "LLAMA_ARG_DEVICE=ROCm0"
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
    PrivateUser = lib.mkForce false;
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
