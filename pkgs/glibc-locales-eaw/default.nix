{
  glibcLocales,
  fetchurl,
  allLocales ? true,
  locales ? [ "en_US.UTF-8/UTF-8" ],
}:

let
  UTF-8-EAW-CONSOLE = fetchurl {
    url = "https://raw.githubusercontent.com/hamano/locale-eaw/6f8d5ddb29da3bde73e3d617ece5ba9fd16c335c/dist/UTF-8-EAW-CONSOLE";
    sha256 = "1d2zmkvaydwf0ra22gg9fms90ja597mxvbd1b05k26mkd91ck675";
  };
in

(glibcLocales.override {
  inherit allLocales;
  inherit locales;
}).overrideAttrs
  (old: {
    preBuild =
      ''
        cp ${UTF-8-EAW-CONSOLE} $(find .. -type d -name 'glibc-2*' | head -n1)/localedata/charmaps/UTF-8-EAW-CONSOLE
        echo 'ja_JP.UTF-8/UTF-8-EAW-CONSOLE \' >> ../glibc-2*/localedata/SUPPORTED
        echo 'en_US.UTF-8/UTF-8-EAW-CONSOLE \' >> ../glibc-2*/localedata/SUPPORTED
      ''
      + old.preBuild;
  })
