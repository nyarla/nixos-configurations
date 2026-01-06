{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "thorium-reader";
  version = "3.3.0";
  src = fetchurl {
    url = "https://github.com/edrlab/thorium-reader/releases/download/v${version}/Thorium-${version}.AppImage";
    hash = "sha256-n6/LAoWgvytJ+M0LEad5YCxOyNkheXQ/CeLeW2RJu54=";
  };
}
