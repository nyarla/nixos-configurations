{ stdenv, fetchFromGitHub, gtk3 }:
stdenv.mkDerivation rec {
  name    = "Newaita-${version}";
  version = "git";
  src     = fetchFromGitHub {
    owner   = "cbrnix";
    repo    = "Newaita";
    rev     = "e80f4c3a3e1905ebc50009df8d57f37660f46b59";
    sha256  = "0083n7m2m6b309vwrf1f7ahi2bf5ah1dzkzb0a5kvwd6adapz8fr";
  };

  nativeBuildInputs = [ gtk3 ];

  installPhase = ''
    mkdir -p $out/share/icons
    mv Newaita-dark $out/share/icons
    mv Newaita      $out/share/icons
  '';

  postFixup = ''
    for base in Newaita{,-dark}; do
      cd $out/share/icons/$base/emblems
      for size in 16 22 24 32 48; do
        ln -sf $size "''${size}@2x"
      done
    done

    gtk-update-icon-cache $out/share/icons/Newaita
    gtk-update-icon-cache $out/share/icons/Newaita-dark
  '';

}
