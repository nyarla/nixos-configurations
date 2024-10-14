{ pkgs, ... }:
{
  boot.kernelModules = [ "snd_aloop" ];
  boot.kernelParams = [ "snd_aloop.index=10" ];

  # add packages to system
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

  # enable to pipewire services
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    # enable to audio backends
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # wireplumber settings
    wireplumber = {
      enable = true;
    };

    # pipewire configurations
    extraConfig = {
      # pipewire daemon
      pipewire = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.allowed-rates" = [
              44100
              48000
              88200
              96000
              176400
              192000
            ];
          };
        };

        "98-focusrite-scalette-2gen" = {
          "device.rules" = [
            {
              matches = [
                { "device.name" = "alsa_card.usb-Focusrite_Scarlett_Solo_USB-00"; }
              ];
              actions = {
                update-props = {
                  "alsa.format" = "S32_LE";
                  "audio.format" = "S32LE";
                };
              };
            }
          ];
        };
        "99-droidcam" = {
          "context.objects" = [
            {
              # for droidcam
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
      };

      # client
      client = {
        "10-no-resampling" = {
          "stream.properties" = {
            "resample.disable" = true;
          };
        };
      };
      client-rt = {
        "10-no-resampling" = {
          "stream.properties" = {
            "resample.disable" = true;
          };
        };
      };

      # pulseaudio
      pipewire-pulse = {
        "10-no-resampling" = {
          "stream.properties" = {
            "resample.disable" = true;
          };
        };

        "90-pacmd" = {
          "pulse.cmd" = [
            {
              cmd = "load-module";
              args = "module-native-protocol-tcp listen=192.168.122.1";
            }
          ];
        };
      };
    };
  };
}
