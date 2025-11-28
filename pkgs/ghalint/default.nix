{
  lib,
  fetchFromGitHub,
  buildGo125Module,
}:
buildGo125Module rec {
  pname = "ghalint";
  version = "v1.5.3";

  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = pname;
    rev = version;
    hash = "sha256-zll71vSqSKIij/TUi4LnGtVqmLhK9UViFDkpnuEvmz8=";
  };

  vendorHash = "sha256-pCrVBgS7eLCYlfY6FyAGAeEhpV2dYQowtE/BoRUju0o=";

  subPackages = [
    "cmd/ghalint"
  ];
}
