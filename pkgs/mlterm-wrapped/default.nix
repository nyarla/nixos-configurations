{
  stdenv,
  mlterm,
  wcwidth-cjk,
  coreutils,
  writeScript,
  runCommand,
}:
let
  mlterm-sh = writeScript "mlterm" ''
    #!${stdenv.shell}

    exec ${wcwidth-cjk}/bin/wcwidth-cjk -- ${mlterm}/bin/mlterm $@
  '';

  mlterm-wl = writeScript "mlterm-wl" ''
    #!${stdenv.shell}

    exec ${wcwidth-cjk}/bin/wcwidth-cjk -- ${mlterm}/bin/mlterm-wl $@
  '';

  mlterm-sdl2 = writeScript "mlterm-sdl2" ''
    exec ${wcwidth-cjk}/bin/wcwidth-cjk -- ${mlterm}/bin/mlterm-sdl2 $@
  '';

  mlterm-fb = writeScript "mlterm-fb" ''
    #!${stdenv.shell}

    export KBD_INPUT_NUM=$(${coreutils}/bin/readlink /dev/input/by-id/usb-25KEYS_zinc_rev.1-event-kbd | ${coreutils}/bin/cut -dt -f2)
    export MOUSE_INPUT_NUM=$(${coreutils}/bin/readlink /dev/input/by-id/usb-PixArt_USB_Optical_Mouse-event-mouse | ${coreutils}/bin/cut -dt -f2)

    exec ${wcwidth-cjk}/bin/wcwidth-cjk -- ${mlterm}/bin/mlterm-fb $@
  '';
in
runCommand "mlterm-wrapped" { } ''
  mkdir -p $out/bin

  cp ${mlterm-sh} $out/bin/mlterm
  cp ${mlterm-wl} $out/bin/mlterm-wl
  cp ${mlterm-sdl2} $out/bin/mlterm-sdl2
  cp ${mlterm-fb} $out/bin/mlterm-fb

  chmod +x $out/bin/*
''
