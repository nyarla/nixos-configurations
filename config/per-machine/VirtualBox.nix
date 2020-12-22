{ pkgs, ... }: {
  # tmp
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = false;

  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # i18n
  i18n.consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-v16n.psf.gz";
  i18n.consoleKeyMap = "jp106";
}
