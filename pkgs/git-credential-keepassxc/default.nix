{ rustPlatform, fetchFromGitHub, lib }:
rustPlatform.buildRustPackage rec {
  pname = "git-credential-keepassxc";
  version = "0.10.1";
  src = fetchFromGitHub {
    owner = "Frederick888";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zVE3RQlh0SEV4iavz40YhR+MP31oLCvG54H8gqXwL/k=";
  };

  cargoSha256 = "sha256-H75SGbT//02I+umttnPM5BwtFkDVNxEYLf84oULEuEk=";
}
