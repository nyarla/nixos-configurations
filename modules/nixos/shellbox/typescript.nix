{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.my.shellbox.typescript;
in
{
  options.my.shellbox.typescript = {
    enable = mkEnableOption "shellbox for typescript";
    tag = mkOption { type = types.str; };

    packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };

    mounts = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    ports = mkOption {
      type = types.listOf types.int;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    my.security.shellbox.shells.typescript = {
      inherit (cfg)
        tag
        mounts
        ports
        ;

      packages =
        (with pkgs; [
          nodejs
          bun

          typescript-language-server
        ])
        ++ cfg.packages;
    };
  };
}
