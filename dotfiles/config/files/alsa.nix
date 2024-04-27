{ pkgs, ... }:
{
  home.file.".asoundrc".text = ''
    pcm.cd {
      type hw
      card 20
      format S16_LE 
      rate 44100
    }

    pcm.dvd {
      type hw
      card 21
      format S24_LE 
      rate 48000
    }

    pcm.hifi {
      type hw
      card 22
      format S24_LE 
      rate 96000
    }

    pcm.ultra {
      type hw
      card 23
      format S24_LE 
      rate 192000
    }
  '';
}
