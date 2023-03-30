{ lib, fetchFromGitHub, rustPackages }:
rustPackages.rustPlatform.buildRustPackage rec {
  pname = "vgpu_unlock-rs";
  version = "2.3.1";
  src = fetchFromGitHub {
    owner = "mbilker";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-h/RNgAO94zpQ8lKKuKEXMF/4XpVan8+l35bwNJcRqhk=";
  };

  cargoSha256 = "sha256-JlX3dfdwxaJJmy5B7Ms+DKb8rNV5sKLTag0Qs8e/eh0=";

  cargoPatches = [ ./lock.patch ];
}
