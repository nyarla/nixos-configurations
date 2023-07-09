{ lib, config, ... }:
let
  kver = config.boot.kernelPackages.kernel.version;
  older = lib.versionOlder kver;
  least = lib.versionAtLeast kver;
in {
  hardware.cpu.amd.updateMicrocode = true;

  # referernces from https://github.com/NixOS/nixos-hardware/blob/master/common/cpu/amd/pstate.nix
  boot = lib.mkMerge [
    (lib.mkIf ((least "5.17") && (older "6.1")) {
      kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
      kernelModules = [ "amd-pstate" ];
    })

    (lib.mkIf ((least "6.1") && (older "6.3")) {
      kernelParams = [ "amd_pstate=passive" ];
    })

    (lib.mkIf (least "6.3") { kernelParams = [ "amd_pstate=passive" ]; })
  ];
}
