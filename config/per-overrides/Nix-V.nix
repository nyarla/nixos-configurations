{ config, ... }: {
  nixpkgs.overlays = [
    (self: super: { ibus-skk = super.ibus-skk.override { layout = "us"; }; })
  ];
}
