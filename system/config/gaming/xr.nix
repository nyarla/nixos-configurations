{ pkgs, ... }:
{
  nixpkgs.xr.enable = true;

  # for ntsync
  boot.kernelModules = [
    "ntsync"
  ];

  boot.kernelPatches = [
    {
      name = "cap_sys_nice_begone";
      patch = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Frogging-Family/community-patches/cbcc5e4d72d22fc08afe81bb517a54b0e01515a5/linux61-tkg/cap_sys_nice_begone.mypatch";
        sha256 = "0ya6b43m0ncjbyi6vyq3ipwwx6yj24cw8m167bd6ikwvdz5yi887";
      };
    }
  ];
}
