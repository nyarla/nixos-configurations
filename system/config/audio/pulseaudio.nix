{ pkgs, ... }:
{
  # for droidcam
  boot.kernelModules = [ "snd_aloop" ];
  boot.kernelParams = [
    "snd_usb_audio.index=11"
    "snd_usb_audio.vid=0x1235"
    "snd_usb_audio.pid=0x8205"
    "snd_aloop.index=10"
    "snd_aloop.id=DroidCam"
    "snd_aloop.enable=1"
  ];

  # packages
  environment.systemPackages = with pkgs; [ pavucontrol ];

  # configuration
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    tcp = {
      enable = true;
      anonymousClients.allowedIpRanges = [ "192.168.122.0/24" ];
    };
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
  };
}
