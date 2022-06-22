{ ... }: {
  boot.kernelParams = [ "v4l2loopback.exclusive_caps=1" ];
  programs.droidcam.enable = true;
}
