{ stdenv, fetchFromGitHub, gtk3 }:
stdenv.mkDerivation rec {
  name = "Newaita-${version}";
  version = "git";
  src = fetchFromGitHub {
    owner = "cbrnix";
    repo = "Newaita";
    rev = "f615f8e38fae858112180998d65b6fc552cfb1dc";
    sha256 = "164k4hig4gmlpas7s4gb5zf8ikqy9y4jhqskzl00x1vg9hps72c7";
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
