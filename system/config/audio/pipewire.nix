{ pkgs, ... }: {
  # for droidcam
  boot.kernelModules = [ "snd_aloop" ];
  boot.kernelParams = [ "snd_aloop.index=10" ];

  # packages
  environment.systemPackages = (with pkgs; [ pavucontrol pipewire ])
    ++ (with pkgs.pipewire; [ out jack pulse ]);

  # temporary fix for `pactl` is not found in pipewire-pulse service
  systemd.user.services.pipewire-pulse.path = with pkgs; [ pulseaudio ];

  # pipewire
  security.rtkit.enable = true;
  services.pipewire = let
    common = {
      "default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
      "default.clock.rate" = 192000;
    };
  in {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    audio.enable = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;

    config = {
      client."context.properties" = { } // common;
      client."stream.properties" = { "node.latency" = "2048/192000"; };

      client-rt."context.properties" = { } // common;
      client-rt."stream.properties" = { "node.latency" = "1024/96000"; };

      pipewire-pulse."context.properties" = { } // common;
      pipewire-pulse."stream.properties" = { "node.latency" = "1024/96000"; };

      jack."context.properties" = { } // common;
      jack."stream.properties" = { "node.latency" = "1024/96000"; };

      pipewire."context.properties" = { } // common;
      pipewire."stream.properties" = {
        "node.latency" = "1024/96000";
        "node.autoconnect" = true;
        "resample.quality" = 10;
      };
      pipewire."context.object" = [
        {
          # bit-perfect for 44100Hz
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "44100Hz";
            "media.class" = "Audio/Duplex";
            "object.linger" = true;
            "audio.channels" = 2;
            "audio.format" = "S16LE";
            "audio.position" = [ "FL" "FR" ];
            "audio.rate" = 44100;
          };
        }
        {
          # bit-perfect for 48000Hz
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "48000Hz";
            "media.class" = "Audio/Duplex";
            "object.linger" = true;
            "audio.channels" = 2;
            "audio.format" = "S24LE";
            "audio.position" = [ "FL" "FR" ];
            "audio.rate" = 48000;
          };
        }
        {
          # bit-perfect for 96000Hz
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "96000Hz";
            "media.class" = "Audio/Duplex";
            "object.linger" = true;
            "audio.channels" = 2;
            "audio.format" = "S24LE";
            "audio.position" = [ "FL" "FR" ];
            "audio.rate" = 96000;
          };
        }
        {
          # for droidcam
          factory = "adapter";
          args = {
            "factory.name" = "api.alsa.pcm.source";
            "node.name" = "DroidCam";
            "object.linger" = true;
            "audio.channels" = 1;
            "api.alsa.path" = "hw:10,1,0";
          };
        }
      ];
    };
  };
}
