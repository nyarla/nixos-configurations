{ pkgs, ... }: {
  sound.enable = true;

  boot.kernelModules = [ "snd_aloop" ];
  boot.kernelParams = [
    "snd_aloop.index=10,20,21,22"
    "snd_aloop.id=DroidCam,44100Hz,48000Hz,96000Hz"
    "snd_aloop.enable=1,1,1,1"
  ];

  environment.systemPackages = with pkgs; [ apulse ];
}
