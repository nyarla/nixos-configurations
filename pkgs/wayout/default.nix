{ rustPlatform, fetchgit, lib, pkgconfig, wayland, egl-wayland, wayland-scanner
, wayland-protocols, patchelf }:
rustPlatform.buildRustPackage rec {
  pname = "wayout";
  version = "git";

  src = fetchgit {
    url = "https://git.sr.ht/~shinyzenith/wayout";
    sha256 = "sha256-EzRetxx0NojhBlBPwhQ7p9rGXDUBlocVqxcEVGIF3+0=";
  };

  buildInputs = [ wayland wayland-scanner wayland-protocols ];
  nativeBuildInputs = [ pkgconfig ];

  cargoSha256 = "sha256-INjMIAkT9rN7XUsmKbQOv5jnEFSdbLjL8g9s/Yiu93k=";

  postFixup = ''
    patchelf --add-rpath ${wayland}/lib $out/bin/wayout
    patchelf --add-needed libwayland-client.so $out/bin/wayout
  '';
}
