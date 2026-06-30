{
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
    hash = "sha256-u85vX9lg5JKUvRjFloE4KZUm/qs8RmjoY/hybtJk/kc=";
  };

  vendorHash = "sha256-n++Rq79KHyRVhIXIdN9IOADTGEG73Wl2SUq/YEo++WM=";

  subPackages = [
    "cmd/ghalint"
  ];
}
