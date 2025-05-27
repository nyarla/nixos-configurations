_: {
  # kernel
  boot.kernelParams = [ "clocksource=hpet" ];
  boot.kernelModules = [
    # enable to tcp bbr
    "tcp_bbr"
  ];

  # sysctl
  boot.kernel.sysctl = {
    # for swap
    "vm.swapiness" = 10;

    # for file watching
    "fs.inotify.max_user_watches" = 1048576; # 1GB

    # for networking
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_window_scaling" = 1;

    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;

    "net.ipv4.tcp_fastopen" = 3;
  };

  # cpu
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";

  # udev
  services.udev.extraRules = ''
    # for audio
    KERNEL=="rtc0", GROUP="audio"
    KERNEL=="hpet", GROUP="audio"
    DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"

    # for storage
    ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
    ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="brq"
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
  '';
}
