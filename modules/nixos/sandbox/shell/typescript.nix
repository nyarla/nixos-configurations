{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.mod.sandbox.shell.typescript;
in
{
  options.mod.sandbox.shell.typescript = {
    enable = mkEnableOption "shellbox for TypeScript";

    ports = mkOption {
      type = types.listOf types.int;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    mod.security.sandbox.shell.apps.typescript = {
      inherit (cfg) ports;

      packages = with pkgs; [
        nodejs
        bun

        typescript-language-server
      ];
    };
  };
}
