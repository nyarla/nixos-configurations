{ stdenv, fetchFromGitHub, gtk3 }:
stdenv.mkDerivation rec {
  name    = "Newaita-${version}";
  version = "git";
  src     = fetchFromGitHub {
    owner   = "cbrnix";
    repo    = "Newaita";
    rev     = "5561b6d18625fd405bff0daaef069fb4d99f0bd3";
    sha256  = "0mfcnpbrm7cmrhq9jrfqa074zm07q373akyc6bz7wdbsngx2z4a5";
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

    find $out/share/icons | grep ' (' | xargs -I{} rm {} 
    find $out/share/icons | grep ' ' | xargs -I{} sh -c 'mv "{}" "$(echo "{}" | sed "s/ //g")"'

    gtk-update-icon-cache $out/share/icons/Newaita
    gtk-update-icon-cache $out/share/icons/Newaita-dark
  '';

}
