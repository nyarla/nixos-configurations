{ config, pkgs, ... }:
let
  jackAudio = with pkgs; [ qjackctl jack2Full a2jmidid jackass wineasio ];
  DAW = with pkgs; [ bitwig-studio3 lmms ];
  bridge = with pkgs; [ linvst linvst3 carla airwave cadence yabridge ];
  plugins = with pkgs; [
    adlplug
    ams-lv2
    bristol
    calf
    dexed
    drumgizmo
    drumkv1
    fluidsynth
    fmsynth
    helm
    hydrogen
    linuxsampler
    synthv1
    yoshimi
    surge-synthesizer
  ];
in {
  boot.kernelModules = [ "snd-seq" "snd-rawmidi" "snd_virmidi" ];

  boot.kernel.sysctl = {
    "vm.swapiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };

  boot.kernelParams = [ "threadirq" "snd_virmidi.midi_devs=1" ];

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

  environment.systemPackages = jackAudio ++ DAW ++ bridge ++ plugins;
  services.dbus.packages = jackAudio ++ DAW ++ bridge;
}
