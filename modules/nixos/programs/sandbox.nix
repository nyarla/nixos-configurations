{ lib, config, ... }:
with lib;
let
  cfg = config.mod.programs.sandbox;
in
{
  options.mod.programs.sandbox.enable = mkEnableOption "Enable sandbox features for linux";

  config = mkIf cfg.enable {
    programs.appimage.enable = true;
    services.flatpak.enable = true;
  };
}
