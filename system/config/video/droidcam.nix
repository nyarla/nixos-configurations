_: {
  boot.kernelModules = [ "snd_aloop" ];
  boot.kernelParams = [
    "v4l2loopback.exclusive_caps=1"
    "snd_aloop.index=10"
  ];

  programs.droidcam.enable = true;

  services.pipewire.extraConfig.pipewire."99-droidcam"."context.objects" = [
    {
      factory = "adapter";
      args = {
        "factory.name" = "api.alsa.pcm.source";
        "node.name" = "DroidCam";
        "object.linger" = true;
        "audio.channels" = 1;
        "api.alsa.path" = "hw:10,1,0";
        "media.class" = "Audio/Source";
      };
    }
  ];
}
