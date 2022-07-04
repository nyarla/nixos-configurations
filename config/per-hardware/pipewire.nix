{ pkgs, ... }: {
  environment.systemPackages = (with pkgs; [ pavucontrol helvum pipewire ])
    ++ (with pkgs.pipewire; [ out jack pulse ]);

  boot.kernelModules = [ "snd_aloop" ];
  boot.kernelParams = [ "snd_aloop.index=10" ];

  # temporary fix for `pactl` it not found
  systemd.user.services.pipewire-pulse.path = [ pkgs.pulseaudio ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    audio.enable = true;
    jack.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;

    config.client = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
        "default.clock.rate" = 192000;
      };
      "stream.properties" = { "node.latecy" = "2048/192000"; };
    };

    config.client-rt = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
        "default.clock.rate" = 192000;
      };
      "stream.properties" = { "node.latecy" = "1024/96000"; };
    };

    config.pipewire-pulse = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
        "default.clock.rate" = 192000;
      };
      "stream.properties" = { "node.latecy" = "1024/96000"; };
    };

    config.jack = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
        "default.clock.rate" = 192000;
      };
      "stream.properties" = { "node.latecy" = "1024/96000"; };
    };

    config.pipewire = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
        "default.clock.rate" = 192000;
      };

      "streams.properties" = {
        "node.latency" = "1024/96000";
        "node.autoconnect" = true;
        "resample.quality" = 10;
      };

      "context.objects" = [
        {
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
