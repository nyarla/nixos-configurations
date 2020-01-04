{ stdenv, fetchurl, electron_5, nodePackages, p7zip, makeDesktopItem }:
stdenv.mkDerivation rec {
  name    = "deezer";
  version = "4.14.1";
  src     = fetchurl {
    url     = "https://www.deezer.com/desktop/download/artifact/win32/x86/${version}";
    sha256  = "0z6z1qdqlxja4vx8248v67axncfc3rzqxx5m1w2xrcmg6rzpsyrc";
  };

  dontStrip = true;

  desktopItem = makeDesktopItem {
    name          = "deezer";
    desktopName   = "Deezer HiFi Desktop";
    comment       = "Deezer HiFi Desktop Music Player";
    genericName   = "Music Player";
    exec          = "@out@/bin/deezer";
    icon          = "deezer";
    startupNotify = "true";
    categories    = ";Audio;";
    extraEntries  = ''
      StartupWMClass="deezer";
    '';
  };

  nativeBuildInputs = [ nodePackages.asar p7zip ];

  unpackPhase = ''
    echo ${src}
    7z x -so ${src} "\''$PLUGINSDIR/app-32.7z"> app-32.7z 
    7z x -y -bsp0 -bso0 app-32.7z
    cd resources
    asar extract app.asar app
  '';

  buildPhase = ''
    sed -i "s|build/linux/systray.png|$out/share/deezer/systray.png|g" app/app/js/main/Utils/index.js 
    sed -i "s|process.resourcesPath,||g" app/app/js/main/Utils/index.js

    rm -r app/node_modules/@nodert

    sed -i 's|webPreferences:{dev|webPreferences:{nodeIntegration:true,dev|g' app/app/js/main/App/index.js
    sed -i 's|nodeIntegration:!1|nodeIntegration:true|g' app/app/js/main/App/index.js
    sed -i 's|urls:\[\"\*\.\"+r.tld\]|urls:\["\*://\*/\*\"\]|g' app/app/js/main/App/index.js
    sed -i 's|urls:\[\"\*\.\*\"\]|urls:\["\*://\*/\*\"\]|g' app/app/js/main/App/index.js

    asar pack app app.asar
  '';

  installPhase = ''
    mkdir -p $out/bin
    echo "#!${stdenv.shell}" >$out/bin/deezer
    echo "exec ${electron_5}/bin/electron ''${out}/share/deezer/app.asar \"\''$@\"" >>$out/bin/deezer
    chmod +x $out/bin/deezer

    mkdir -p $out/share/deezer
    cp app.asar $out/share/deezer/

    mkdir -p $out/share/icons/hicolor/256x256/apps/
    cp build/win/app.ico $out/share/icons/hicolor/256x256/apps/deezer.png
    cp build/win/systray.png $out/share/deezer/systray.png

    mkdir -p $out/share/applications/
    substitute $desktopItem/share/applications/deezer.desktop \
      $out/share/applications/deezer.desktop \
      --subst-var out 
  '';
}
