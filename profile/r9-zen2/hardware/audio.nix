_: {
  mod.audio.pipewire = {
    enable = true;

    supportedSampleRates = [
      44100
      48000
      88200
      96000
      176400
      192000
    ];

    deviceConfig = {
      "focusrite-scalette-2gen" = {
        device = "alsa_card.usb-Focusrite_Scarlett_Solo_USB-00";
        alsa = "S32_LE";
        audio = "S32LE";
      };
    };
  };
}
