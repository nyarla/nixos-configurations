{
  lib,
  fetchFromGitHub,
  rustPackages,
}:
rustPackages.rustPlatform.buildRustPackage rec {
  pname = "vgpu_unlock-rs";
  version = "2.3.1";
  src = fetchFromGitHub {
    owner = "mbilker";
    repo = "vgpu_unlock-rs";
    rev = "44d5bb32ecd8bdcfe374772c31078a6e4eef921f";
    hash = "sha256-0NPGk35tCgAYWbfs4FG9/p6RuvqUY1L33sobMSIeh/s=";
  };

  cargoSha256 = "sha256-zy0B2PE0xHRfKULnaqXBEsR9P9PGvLnzVopWfBH0W0c=";
  cargoPatches = [ ./lock.patch ];
}
