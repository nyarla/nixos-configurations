{ pkgs, ... }: {
  environment.systemPackages = (with pkgs; [ pavucontrol helvum ])
    ++ (with pkgs.pipewire; [ out jack pulse ]);
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
      "stream.properties" = {
        "context.properties" = {
          "default.clock.allowed-rates" = [ 44100 48000 96000 ];
          "default.clock.rate" = 96000;
          "default.clock.quantum" = 512;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 1024;
        };
        "node.latecy" = "512/192000";
      };
    };

    config.client-rt = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 ];
        "default.clock.rate" = 96000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };
      "stream.properties" = { "node.latecy" = "512/96000"; };
    };

    config.pipewire-pulse = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 ];
        "default.clock.rate" = 96000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };
      "stream.properties" = {
        "node.latecy" = "512/96000";
        "channelmix.upmix" = false;
      };
    };

    config.jack = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 ];
        "default.clock.rate" = 96000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };
      "stream.properties" = { "node.latecy" = "512/96000"; };
    };

    config.pipewire = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 44100 48000 96000 ];
        "default.clock.rate" = 96000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };

      "streams.properties" = {
        "node.latency" = "512/96000";
        "node.autoconnect" = true;
        "resample.quality" = 15;
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
            "node.name" = "96000Hz";
            "media.class" = "Audio/Duplex";
            "object.linger" = true;
            "audio.channels" = 2;
            "audio.format" = "S24LE";
            "audio.position" = [ "FL" "FR" ];
            "audio.rate" = 96000;
          };
        }
      ];
    };
  };
}
