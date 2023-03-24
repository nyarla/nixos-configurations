{ pkgs, ... }: {
  # for droidcam
  boot.kernelModules = [ "snd_aloop" ];
  boot.kernelParams = [
    "snd_usb_audio.index=11"
    "snd_usb_audio.vid=0x1235"
    "snd_usb_audio.pid=0x8205"
    "snd_aloop.index=10,20,21,22,23"
    "snd_aloop.id=DroidCam,CD,DVD,HiFi,Ultra"
    "snd_aloop.enable=1,1,1,1,1"
  ];

  # packages
  environment.systemPackages = with pkgs; [ pavucontrol pulseaudioFull ];

  # configuration
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    daemon.config = {
      avoid-resampling = "yes";
      alternate-sample-rate = 192000;
      default-channel-map = "front-left,front-right";
      default-fragments = 2;
      default-sample-channels = 2;
      default-sample-format = "s24le";
      default-sample-rate = 192000;
      flat-volumes = "no";
      high-priority = "yes";
      resample-method = "soxr-vhq";
    };
    extraConfig = ''
      load-module module-device-manager
    '';
  };

  # ignore midi devices
}
