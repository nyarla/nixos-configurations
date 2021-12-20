{ config, pkgs, ... }:
let
  daw = with pkgs; [ bitwig-studio3 helio-workstation zrythm seq66 ];
  jack = with pkgs; [ a2jmidid jack2Full qjackctl carla jack_capture japa ];
  plugins = with pkgs; [
    adlplug
    ams-lv2
    bristol
    calf
    # dexed
    drumgizmo
    drumkv1
    fluidsynth
    fmsynth
    helm
    hydrogen
    linuxsampler
    # surge-synthesizer
    synthv1
    yoshimi
  ];

  packages = daw ++ jack ++ plugins;
in {
  boot.kernelModules = [ "snd-seq" "snd-rawmidi" "snd_virmidi" ];
  boot.kernel.sysctl = {
    "vm.swapiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };
  boot.kernelParams = [
    "threadirq"
    "snd_virmidi.index=1,2"
    "snd_virmidi.enable=1,1"
    "snd_virmidi.midi_devs=4,4"
  ];
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "99999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "99999";
    }
  ];

  environment.systemPackages = packages;
}
