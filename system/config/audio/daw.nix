{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ currennt ];
  boot.kernelModules = [ "snd-seq" "snd-rawmidi" "snd-virmidi" ];
  boot.kernel.sysctl = {
    "vm.swapiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };
  boot.kernelParams =
    [ "threadirq" "snd-virmidi.enable=1,1" "snd-virmidi.midi_devs=4,4" ];
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
}
