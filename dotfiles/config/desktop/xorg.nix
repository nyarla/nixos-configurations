{ pkgs, ... }: {
  services.screen-locker = let
    wallpaper = pkgs.fetchurl {
      url =
        "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-stripes.png";
      sha256 = "116337wv81xfg0g0bsylzzq2b7nbj6hjyh795jfc9mvzarnalwd3";
    };

    script = pkgs.writeShellScript "lock" ''
      ${pkgs.i3lock-color}/bin/i3lock-color \
      -k \
      -i ${wallpaper} -L \
      --inside-color=00000000 \
      --insidever-color=00000000 \
      --insidewrong-color=00000000 \
      --ring-color=00000000 \
      --ringver-color=FFFFFF99 \
      --ringwrong-color=FF333399 \
      --line-color=00000000 \
      --keyhl-color=FFFFFF66 \
      --bshl-color=FFFFFF33 \
      --separator-color=00000000 \
      --date-str="%A" \
      --verif-text="" \
      --wrong-text="" \
      --noinput-text=""
    '';
  in {
    enable = true;
    lockCmd = toString script;
    inactiveInterval = 1;
    xss-lock.screensaverCycle = 60;
    xautolock.enable = false;
  };

  systemd.user.services.xss-lock.Service.Environment =
    [ "LANG=ja_JP.UTF-8" "LC_ALL=ja_JP.UTF-8" ];
}
