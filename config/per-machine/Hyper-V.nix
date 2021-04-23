{ pkgs, ... }: {
  # tmp
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = false;

  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # i18n
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v16n.psf.gz";

}
