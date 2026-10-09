{ lib, config, ... }:
with lib;
let
  cfg = config.my.hardware.cpu.amd;
in
{
  options.my.hardware.cpu.amd = {
    enable = mkEnableOption "use AMD cpu";
    fix.zen2.enable = mkEnableOption "use workaround for Zen2 CPU";
  };

  config = mkIf cfg.enable {
    hardware.cpu.amd.updateMicrocode = true;
    boot.kernelParams = mkIf cfg.fix.zen2.enable [ "processor.max_cstate=1" ];
  };
}
