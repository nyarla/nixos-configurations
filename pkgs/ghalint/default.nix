{
  lib,
  fetchFromGitHub,
  buildGo126Module,
}:
buildGo126Module rec {
  pname = "ghalint";
  version = "v1.5.4";

  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = pname;
    rev = version;
    hash = "sha256-pfLXnMbrxXAMpfmjctah85z5GHfI/+NZDrIu1LcBH8M=";
  };

  vendorHash = "sha256-VCv5ZCeUWHld+q7tkHSUyeVagMhSN9893vYHyO/VlAI=";

  subPackages = [
    "cmd/ghalint"
  ];
}
