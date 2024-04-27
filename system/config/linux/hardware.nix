{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    multipath-tools
    pciutils
    usbutils
  ];

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
    ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
    ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
  '';
}
