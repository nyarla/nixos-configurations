{ lib, config, ... }:
with lib;
let
  cfg = config.mod.wireless.bluetooth;
in
{
  options.mod.wireless.bluetooth.enable = mkEnableOption "Enable services for Bluetooth";

  config = mkIf cfg.enable {
    services.blueman.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          ClassicBondedOnly = "false";
          UserspaceHID = "false";
        };
      };
    };
  };
}
