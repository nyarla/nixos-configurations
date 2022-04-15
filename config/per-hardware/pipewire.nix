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

    config.pipewire = {
      "context.properties" = {
        "default.clock.allowed-rates" = [ 41000 48000 96000 192000 ];
        "default.clock.rate" = 192000;
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 1024;
      };

      "streams.properties" = {
        "node.latency" = "512/192000";
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
            "audio.channels" = 2;
            "audio.format" = "S24LE";
            "audio.position" = [ "FL" "FR" ];
            "audio.rate" = 96000;
          };
        }
      ];

      #     "context.modules" = [{
      #       name = "libpipewire-module-loopback";
      #       args = {
      #         "audio.position" = [ "FL" "FR" ];
      #         "capture.props" = {
      #           "media.class" = "Audio/Sink";

      #           "node.name" = "44100Hz-capture";
      #           "node.description" = "44100Hz_capture";

      #           "node.latency" = "512/44100";
      #           "node.lock-quantum" = true;
      #           "node.force-quantum" = 512;
      #           "node.passive" = false;
      #           "audio.rate" = 44100;
      #           "audio.channels" = 2;
      #           "audio.format" = "S16LE";
      #           "audio.position" = [ "FL" "FR" ];
      #           "resample.disable" = true;
      #           "channelmix.disable" = true;
      #           "node.target" = "44100Hz";
      #           "monitor.channel-volumes" = false;
      #         };
      #         "playback.props" = {
      #           "media.class" = "Audio/Source";

      #           "node.name" = "44100Hz-source";
      #           "node.description" = "44100Hz_source";

      #           "node.latency" = "512/44100";
      #           "node.lock-quantum" = true;
      #           "node.force-quantum" = 512;
      #           "node.passive" = false;
      #           "audio.rate" = 44100;
      #           "audio.channels" = 2;
      #           "audio.format" = "S16LE";
      #           "audio.position" = [ "FL" "FR" ];
      #           "resample.disable" = true;
      #           "channelmix.disable" = true;
      #           "monitor.channel-volumes" = false;
      #         };
      #       };
      #     }];
    };
  };
}
