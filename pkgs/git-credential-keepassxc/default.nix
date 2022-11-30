{ rustPlatform, fetchFromGitHub, lib }:
rustPlatform.buildRustPackage rec {
  pname = "git-credential-keepassxc";
  version = "0.11.0";
  src = fetchFromGitHub {
    owner = "Frederick888";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZpysJ+xs3IenqAdoswG0OkzxzuNPSKkqlutGxn4VRw8=";
  };

  cargoSha256 = "sha256-IPsMlVfgwoFEQlXmW4gnt16WNF5W6akobUVct/iF42E=";
}
