{ pkgs, ... }: {
  services.mpd = {
    enable = true;
    musicDirectory = "/run/media/nyarla/src/Music";
    network = { listenAddress = "0.0.0.0"; };
    extraConfig = ''
      resampler {
        plugin "libsamplerate"
        type "0"
      }

      replaygain "off"

      audio_output {
        type "alsa"
        name "Focusrite"
        device "hw:USB"

        mixer_type "none"
        replay_gain_handler "none"

        auto_resample "no"
        auto_channels "no"
        auto_format "no"  
      }
    '';
  };

  systemd.user.services.mympd = {
    Unit = {
      Description = "Screen lock services by sway utilites";
      After = [ "network.target" ];
      PartOf = [ "network.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart =
        "${pkgs.mympd}/bin/mympd mympd -u nyarla -w /home/nyarla/.config/mympd -a /home/nyarla/.cache/mympd";
    };

    Install = { WantedBy = [ "network.target" ]; };
  };
}
