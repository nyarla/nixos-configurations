{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.services.pipewire;
in
{
  options.my.services.pipewire = {
    enable = mkEnableOption "pipewire servcie";

    sampleRates = mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
    };

    formats = mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }: {
            options = {
              name = mkOption {
                type = lib.types.str;
                default = name;
              };
              device = mkOption {
                type = lib.types.str;
              };
              alsa = mkOption {
                type = lib.types.str;
              };
              audio = mkOption {
                type = lib.types.str;
              };
            };
          }
        )
      );
      default = { };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        pwvucontrol
        pulseaudio
      ]
      ++ (with pipewire; [
        out
        jack
      ]);

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;

      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber.enable = true;

      extraConfig =
        let
          clock."10-clock-rate"."context.properties"."default.clock.allowed-rates" = cfg.sampleRates;
        in
        {
          pipewire =
            clock
            // lib.attrsets.concatMapAttrs (name: value: {
              "98-${name}"."device.rules" = [
                {
                  matches = [
                    { "device.name" = value.device; }
                  ];

                  actions.update-props = {
                    "alsa.format" = value.alsa;
                    "audio.format" = value.audio;
                  };
                }
              ];
            }) cfg.formats;
          client = clock;
          jack = clock;
          pipewire-pulse = clock;
        };
    };
  };
}
