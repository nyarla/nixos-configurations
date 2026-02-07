{
  lib,
  fetchFromGitHub,
  buildGo126Module,
}:
buildGo126Module rec {
  pname = "ghalint";
  version = "v1.5.5";

  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = pname;
    rev = version;
    hash = "sha256-xAXcvvSwcJjdG2BCItBLdsu6vZiID5FmRYYF9PZe1QE=";
  };

  vendorHash = "sha256-XIalA/usvyvzrvGU7Ygf1DWSlTm1YYaN+X0Xm+YiiTI=";

  subPackages = [
    "cmd/ghalint"
  ];
}
