{ lib, config, ... }:
with lib;
let
  cfg = config.my.box.deadbeef;
in
{
  options.my.box.deadbeef = {
    enable = mkEnableOption "deadbeef";

    user = {
      user = mkOption { type = types.str; };
      group = mkOption { type = types.str; };
      uid = mkOption { type = types.int; };
      gid = mkOption { type = types.int; };
    };

    library = mkOption { type = types.str; };

    package = mkOption { type = types.package; };
  };

  config = mkIf cfg.enable {
    my.security.box.apps.deadbeef = {
      user = {
        inherit (cfg.user)
          user
          group
          uid
          gid
          ;
        home = "/home/${cfg.user.user}";
      };

      wayland.enable = true;
      audio.enable = true;

      mounts.ro = [ cfg.library ];
      mounts.rw = [
        "/home/${cfg.user.user}/.config/deadbeef"
      ];

      inherit (cfg) package;

      command = "deadbeef";
    };
  };
}
