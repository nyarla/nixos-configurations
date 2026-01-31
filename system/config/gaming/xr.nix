_: {
  nixpkgs.xr.enable = true;

  # for ntsync
  boot.kernelModules = [
    "ntsync"
  ];
}
