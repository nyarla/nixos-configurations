{ stdenv, mlterm, wcwidth-cjk, zsh, coreutils, writeScript, runCommand }:
let
  mlterm-sh = writeScript "mlterm" ''
    #!${stdenv.shell}

    cd $HOME
    ${wcwidth-cjk}/bin/wcwidth-cjk -- ${mlterm}/bin/mlterm -e ${zsh}/bin/zsh --login &
  '';

  mlterm-wl = writeScript "mlterm-wl" ''
    #!${stdenv.shell}

    cd $HOME
    ${wcwidth-cjk}/bin/wcwidth-cjk -- ${mlterm}/bin/mlterm-wl -e ${zsh}/bin/zsh --login &
  '';

  mlterm-fb = writeScript "mlterm-fb" ''
    #!${stdenv.shell}

    export KBD_INPUT_NUM=$(${coreutils}/bin/readlink /dev/input/by-id/usb-25KEYS_zinc_rev.1-event-kbd | ${coreutils}/bin/cut -dt -f2)
    export MOUSE_INPUT_NUM=$(${coreutils}/bin/readlink /dev/input/by-id/usb-PixArt_USB_Optical_Mouse-event-mouse | ${coreutils}/bin/cut -dt -f2)

    cd $HOME
    ${wcwidth-cjk}/bin/wcwidth-cjk -- ${mlterm}/bin/mlterm-fb -e ${zsh}/bin/zsh --login &
  '';
in runCommand "mlterm-wrapped" { } ''
  mkdir -p $out/bin

  cp ${mlterm-sh} $out/bin/mlterm
  cp ${mlterm-wl} $out/bin/mlterm-wl
  cp ${mlterm-fb} $out/bin/mlterm-fb

  chmod +x $out/bin/*
''
