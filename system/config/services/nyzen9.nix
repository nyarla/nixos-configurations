{ pkgs, lib, ... }:
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

  services.flaresolverr.enable = true;

  services.caddy = {
    enable = true;
    virtualHosts = {
      # for private services
      "search.p.localhost.thotep.net" = {
        listenAddresses = [ "100.103.65.77" ];
        useACMEHost = "localhost.thotep.net";
        logFormat = ''
          output stdout
        '';
        extraConfig = ''
          reverse_proxy 127.0.0.1:40001
        '';
      };
      # for development
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

  services.searx = {
    enable = true;
    settings = {
      use_default_settings = {
        engines.keep_only = [ ];
      };

      ui = {
        default_locale = "ja";
      };

      server = {
        base_url = "https://search.p.localhost.thotep.net";
        port = 40001;
        bind_address = "127.0.0.1";
      };

      search = {
        safe_search = 0;
        autocomplete = "duckduckgo";
        favicon_resolver = "google";
        default_lang = "auto";
        languages = [
          "all"
          "ja"
          "en-US"
        ];
      };

      categories_as_tabs = {
        # default categories
        general = { };
        images = { };
        videos = { };
        music = { };
      };

      engines =
        let
          toEngine = tab: engine: engine // { categories = [ tab ]; };
          define =
            tabs:
            lib.flatten (
              lib.attrsets.mapAttrsToList (_: engine: engine) (
                lib.attrsets.mapAttrs (tab: engines: (lib.forEach engines (engine: toEngine tab engine))) tabs
              )
            );
        in
        define {
          # default categories
          general = [
            {
              name = "duckduckgo";
              engine = "duckduckgo";
              shortcut = "duck";
            }
            {
              name = "google";
              engine = "google";
              shortcut = "google";
            }
          ];

          images = [
            {
              name = "google images";
              engine = "google_images";
              shortcut = "images";
            }
          ];

          videos = [
            {
              name = "youtube";
              engine = "youtube_noapi";
              shortcut = "tube";
            }
            {
              name = "niconico";
              engine = "xpath";
              shortcut = "nico";

              paging = true;
              template = "video.html";

              search_url = ''https://www.nicovideo.jp/search/{query}?page={pageno}&sort=n&order=d'';

              url_xpath = ''//li[@data-video-id]//p[@class="itemTitle"]/a/@href'';
              title_xpath = ''//li[@data-video-id]//p[@class="itemTitle"]/a'';
              content_xpath = ''//li[@data-video-id]//p[@class="itemDescription"]'';
              thumbnail_xpath = ''//li[@data-video-id]//img[@class="thumb"]/@src'';
              suggestion_xpath = ''//div[@class="tagListBox"]/ul[@class="tags"]//li[@class="item"]'';
            }
          ];

          # custom categories
          apps = [
            {
              name = "fdroid";
              engine = "fdroid";
              shortcut = "fdroid";
            }
            {
              name = "google play store";
              engine = "google_play";
              shortcut = "playapp";
              play_categ = "apps";
            }
          ];

          dev = [
            {
              name = "github";
              engine = "github";
              shortcut = "github";
            }
            {
              name = "metacpan";
              engine = "metacpan";
              shortcut = "cpan";
              disabled = false;
            }
            {
              name = "npm";
              engine = "npm";
              shortcut = "npm";
            }
          ];

          website = [
            {
              name = "the.kalaclista.com";
              engine = "xpath";
              shortcut = "blog";

              search_url = "https://the.kalaclista.com/search?q={query}";
              url_xpath = ''//a[@class="entry-title-link"]/@href'';
              title_xpath = ''//a[@class="entry-title-link"]'';
              content_xpath = ''//div[@class="archive-entry-body"]'';
              no_result_for_http_status = [ 404 ];
            }
            {
              name = "let.kalaclista.com";
              engine = "xpath";
              shortcut = "essay";

              search_url = "https://let.kalaclista.com/search?q={query}";
              url_xpath = ''//a[@class="entry-title-link"]/@href'';
              title_xpath = ''//a[@class="entry-title-link"]'';
              content_xpath = ''//div[@class="archive-entry-body"]'';
              no_result_for_http_status = [ 404 ];
            }
          ];

        };
    };
    environmentFile = "/persist/home/nyarla/.config/searxng/env";
  };

}
