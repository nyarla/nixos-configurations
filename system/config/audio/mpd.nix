{ pkgs, lib, ... }: {
  boot.kernelParams = [
    "snd_usb_audio.index=11"
    "snd_usb_audio.vid=0x1235"
    "snd_usb_audio.pid=0x8205"
  ];
}
