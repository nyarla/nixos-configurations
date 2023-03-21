{ pkgs, lib, ... }: {
  # for droidcam
  boot.kernelModules = [ "snd_aloop" ];
  boot.kernelParams = [ "snd_aloop.index=10" ];

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
      load-module module-null-sink sink_name=44100Hz sink_properties=device.description=44100Hz format=s16le rate=44100 channels=2 formats=pcm
      load-module module-null-sink sink_name=48000Hz sink_properties=device.description=48000Hz format=s24le rate=48000 channels=2 formats=pcm
      load-module module-null-sink sink_name=96000Hz sink_properties=device.description=96000Hz format=s24le rate=96000 channels=2 formats=pcm

      load-module module-loopback source=44100Hz.monitor source_dont_move=true adjust_time=0 remix=false format=s16le rate=44100 channels=2
      load-module module-loopback source=48000Hz.monitor source_dont_move=true adjust_time=0 remix=false format=s24le rate=48000 channels=2
      load-module module-loopback source=96000Hz.monitor source_dont_move=true adjust_time=0 remix=false format=s24le rate=96000 channels=2
    '';
  };

  # ignore midi devices
}
