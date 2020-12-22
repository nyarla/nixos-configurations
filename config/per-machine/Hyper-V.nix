{ pkgs, ... }: {
  # tmp
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = false;

  # bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # i18n
  i18n.consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-v16n.psf.gz";

  # hardware
  # hardware.opengl.enable = true;
  # hardware.opengl.driSupport = true;
  # hardware.opengl.driSupport32Bit = true;
  # hardware.opengl.s3tcSupport = true;

  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;
  # hardware.pulseaudio.package = pkgs.pulseaudioFull.overrideAttrs (old: rec {
  #   postInstall = ''
  #     export PULSE_DIR=''$(pwd)

  #     tar -zxvf "${pkgs.fetchurl {
  #       url     = "https://github.com/neutrinolabs/pulseaudio-module-xrdp/archive/v0.2.tar.gz";
  #       sha256  = "0jkmsqkdbd61ib2c2hj17skhmzcrkjj4h83a439csxlxnxxsz538"; 
  #     }}"

  #     cd pulseaudio-module-xrdp-0.2
  #     ./bootstrap
  #     PKG_CONFIG_PATH="''$PKG_CONFIG_PATH:$out/lib/pkgconfig:$dev/lib/pkgconfig" ./configure
  #     make
  #     make install
  #   '' + old.postInstall;
  # });
  # hardware.pulseaudio.daemon.config = {
  #   flat-volumes = "no";
  # };

  i18n.consoleUseXkbConfig = true;
  services.xserver.layout = "jp";
  services.xserver.xkbModel = "jp106";
  services.xserver.xkbOptions = "ctrl:nocaps";
}
