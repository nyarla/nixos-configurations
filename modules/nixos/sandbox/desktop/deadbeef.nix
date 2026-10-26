{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.mod.sandbox.desktop.deadbeef;
in
{
  options.mod.sandbox.desktop.deadbeef = {
    enable = mkEnableOption "Use DeaDBeeF";

    library = mkOption { type = types.str; };

    package = mkOption { type = types.package; };
  };

  config = mkIf cfg.enable {
    mod.security.sandbox.desktop.apps.deadbeef = {
      features = {
        wayland.enable = true;
        audio.enable = true;
      };

      mounts = {
        ro = [ cfg.library ];
        rw = [ "${config.mod.security.sandbox.settings.user.home}/.config/deadbeef" ];
      };

      inherit (cfg) package;
      executable = "deadbeef";
    };
  };
}
