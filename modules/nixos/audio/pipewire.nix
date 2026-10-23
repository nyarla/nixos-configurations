{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.mod.audio.pipewire;
in
{
  options.mod.audio.pipewire = {
    enable = mkEnableOption "Enable the PipeWire service.";

    supportedSampleRates = mkOption {
      default = [ ];
      type = types.listOf types.int;
    };

    deviceConfig = mkOption {
      default = { };
      type = types.attrsOf (
        types.submodule (
          { name, ... }: {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
              };

              device = mkOption { type = types.str; };
              alsa = mkOption { type = types.str; };
              audio = mkOption { type = types.str; };
            };
          }
        )
      );
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
          clock."10-clock-rate"."context.properties"."default.clock.allowed-rates" = cfg.supportedSampleRates;
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
            }) cfg.deviceConfig;
          client = clock;
          jack = clock;
          pipewire-pulse = clock;
        };
    };
  };
}
