{ pkgs, ... }:
let
  swaylock-script = toString (
    with pkgs;
    writeShellScript "swaylock.sh" ''
      ${swayidle}/bin/swayidle -w \
        timeout 60 'swaylock -C ~/.config/swaylock/config -f' \
        timeout 60 '${wayout}/bin/wayout --off HDMI-A-1' resume '${wayout}/bin/wayout --on HDMI-A-1'
        before-sleep 'swaylock -C ~/.config/swaylock/config -f' \
        lock 'swaylock -C ~/.config/swaylock/config -f'
    ''
  );

  image = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/wallpapers/nix-wallpaper-stripes.png";
    sha256 = "116337wv81xfg0g0bsylzzq2b7nbj6hjyh795jfc9mvzarnalwd3";
  };
in
{
  programs.swaylock.enable = true;
  programs.swaylock.package = pkgs.swaylock-effects;
  programs.swaylock.settings = {
    image = toString image;
    inside-color = "00000000";
    inside-ver-color = "00000000";
    inside-wrong-color = "00000000";
    ring-color = "00000000";
    ring-ver-color = "FFFFFF99";
    ring-wrong-color = "FF333399";
    line-color = "00000000";
    key-hl-color = "FFFFFF66";
    bs-hl-color = "FFFFFF33";
    separator-color = "00000000";
    datestr = "%A";
  };

  systemd.user.services.swaylock = {
    Unit = {
      Description = "Screen lock services by sway utilites";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      Restart = "on-failure";
      ExecStart = swaylock-script;
    };
  };
}
