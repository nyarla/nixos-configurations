{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "goreman";
  version = "0.3.15";
  src = fetchFromGitHub {
    owner = "mattn";
    repo = "goreman";
    rev = "ebb9736b7c7f7f3425280ab69e1f7989fb34eadc";
    hash = "sha256-Z6b245tC6UsTaHTTlKEFH0egb5z8HTmv/554nkileng=";
  };

  vendorHash = "sha256-Qbi2GfBrVLFbH9SMZOd1JqvD/afkrVOjU4ECkFK+dFA=";
}
