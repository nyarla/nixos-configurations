{ pkgs, lib, ... }: {
  services.mpd = {
    enable = true;
    musicDirectory = "/run/media/nyarla/src/Music";
    network = { listenAddress = "0.0.0.0"; };
    user = "nyarla";
    group = "users";
    extraConfig = ''
      replaygain "off"

      volume_normalization "no"

      audio_output {
        type    "alsa"
        name    "Focusrite"
        device  "hw:11,0"

        mixer_type "disabled"

        replay_gain_handler "none"

        auto_resample "no"
        auto_channels "no"
        auto_format   "no"
      }
    '';
  };

  boot.kernelParams = [ "snd_usb_audio.index=11" ];
}
