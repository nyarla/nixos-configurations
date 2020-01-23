{ config, pkgs, ... }:
{
  boot.kernelModules = [
    "snd-seq" "snd-rawmidi" "snd_virmidi"
  ];

  boot.kernel.sysctl = {
    "vm.swapiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };

  boot.kernelParams = [
    "threadirq"
    "snd_virmidi.midi_devs=1"
  ];

  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock";  type = "-";     value = "unlimited";  }
    { domain = "@audio"; item = "rtprio";   type = "-";     value = "99";         }
    { domain = "@audio"; item = "nofile";   type = "soft";  value = "99999";      }
    { domain = "@audio"; item = "nofile";   type = "hard";  value = "99999";      }
  ];

  environment.systemPackages = with pkgs; [
    qjackctl jack2 a2jmidid bitwig-studio3 linvst linvst3 airwave carla
  ];

  services.dbus.packages = with pkgs; [
    qjackctl jack2 a2jmidid bitwig-studio3 linvst linvst3 airwave carla
  ];
}
