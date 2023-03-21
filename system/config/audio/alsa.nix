{ pkgs, ... }: {
  sound.enable = true;

  boot.kernelModules = [ "snd_aloop" ];
  boot.kernelParams = [
    "snd_usb_audio.index=11"
    "snd_usb_audio.vid=0x1235"
    "snd_usb_audio.pid=0x8205"
    "snd_aloop.index=10,20,21,22,23"
    "snd_aloop.id=DroidCam,CD,DVD,HiFi,Ultra"
    "snd_aloop.enable=1,1,1,1,1"
  ];

  environment.systemPackages = with pkgs; [ apulse ];
}
