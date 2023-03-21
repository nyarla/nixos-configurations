{ pkgs, ... }: {
  home.file.".asoundrc" = toString (pkgs.writeText "asoundrc" ''
    pcm.usb {
      type dmix
      ipc_key 1024
      slave {
        pcm "hw:11,0"
        period_time 0
        period_size 1024
        buffer_size 4096
        format S24_LE
        rate 192000
      }

      bindings {
        0 0
        1 1
      }
    }

    pcm.dsp0 {
      type plug
      slave.pcm "usb"
    }

    ctl.mixer0 {
      type hw
      card 11
    }

    pcm.!default {
      type plug
      slave.pcm "dmix"
    }

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

    pcm.hifi {
      type hw
      card 23
      format S24_LE 
      rate 192000
    }

    defaults.pcm.card 11
    defaults.ctl.card 11 
  '');
}
