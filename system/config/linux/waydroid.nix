{ lib, pkgs, ... }:
{
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  environment.etc."gbinder.d/waydroid.conf".source = lib.mkForce (
    pkgs.writeText "waydroid.conf" ''
      [Protocol]
      /dev/binder = aidl3
      /dev/vndbinder = aidl3
      /dev/hwbinder = hidl

      [ServiceManager]
      /dev/binder = aidl3
      /dev/vndbinder = aidl3
      /dev/hwbinder = hidl

      [General]
      ApiLevel = 30
    ''
  );
}
