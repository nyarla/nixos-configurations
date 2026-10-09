{ lib, config, ... }:
with lib;
let
  cfg = config.my.programs.droidcam;
in
{
  options = {
    my.programs.droidcam.enable = mkEnableOption "DroidCam support";
  };

  config = mkIf cfg.enable {
    programs.droidcam.enable = true;

    boot.kernelParams = [
      "v4l2loopback.exclusive_caps=1"
      "snd_aloop.index=10"
    ];

    services.pipewire.extraConfig.pipewire."99-droidcam"."context.objects" = [
      {
        factory = "adapter";
        args = {
          "factory.name" = "api.alsa.pcm.source";
          "node.name" = "DroidCam";
          "object.linger" = true;
          "audio.channels" = 1;
          "api.alsa.path" = "hw:10,1,0";
          "media.class" = "Audio/Source";
        };
      }
    ];
  };
}
