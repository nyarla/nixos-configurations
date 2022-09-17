{ pkgs, lib, ... }: { boot.kernelParams = [ "snd_usb_audio.index=11" ]; }
