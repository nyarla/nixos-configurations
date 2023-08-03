{ pkgs, ... }: {
  services.screen-locker = {
    enable = true;
    lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    inactiveInterval = 1;
    xss-lock.screensaverCycle = 60;
    xautolock.enable = false;
  };
}
