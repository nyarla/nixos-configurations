{ pkgs, ... }: {
  nixpkgs.overlays = [
    (self: super: rec {
      spice-gtk = super.callPackage (import "${super.fetchurl {
        url =
          "https://raw.githubusercontent.com/NixOS/nixpkgs/5c5f2b547f20b7801231253f070a93e1ed9a8546/pkgs/development/libraries/spice-gtk/default.nix";
        sha256 = "02q4phsmwf540dq4h7n43whc1cmf1kv0g6qpv20yhcc714k4mwpc";
      }}") { };
    })
  ];
}
