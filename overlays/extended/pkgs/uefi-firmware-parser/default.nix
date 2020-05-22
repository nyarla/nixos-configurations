{ stdenv, fetchurl, python3Packages }:
python3Packages.buildPythonPackage rec {
  name = "uefi-firmware-parser";
  version = "1.8";
  src = fetchurl {
    url = "https://github.com/theopolis/uefi-firmware-parser/archive/v1.8.tar.gz";
    sha256 = "06685rg62vnq1xi4adqdq13jz0s7cl6mz3bwwx7v90v050fi5qql";
  };
}
