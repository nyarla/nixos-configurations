{
  glibcLocales,
  fetchurl,
  allLocales ? true,
  locales ? [ "en_US.UTF-8/UTF-8" ],
}:

let
  UTF-8-EAW-CONSOLE = fetchurl {
    url = "https://raw.githubusercontent.com/hamano/locale-eaw/257ec45a95e377a397483a29f524c6648d4fe925/dist/UTF-8-EAW-CONSOLE";
    sha256 = "0rnwgav20ijr5zvbvy9wix5isq2gw4fp6m89ijyszfy337aqb7s5";
  };
in

(glibcLocales.override {
  inherit allLocales;
  inherit locales;
}).overrideAttrs
  (old: {
    preBuild = ''
      cp ${UTF-8-EAW-CONSOLE} ../localedata/charmaps/UTF-8-EAW-CONSOLE
      chmod +w ../localedata/charmaps/UTF-8-EAW-CONSOLE

      substituteInPlace ../localedata/charmaps/UTF-8-EAW-CONSOLE \
        --replace-fail "<U2190>...<U21FF> 2" "<U2190>...<U21FF> 1" \
        --replace-fail "<U0001F100>...<U0001F77F> 2" "<U0001F100>...<U0001F1E5> 2\n<U0001F200>...<U0001F77F> 2"

      echo 'ja_JP.UTF-8/UTF-8-EAW-CONSOLE \' >> ../localedata/SUPPORTED
      echo 'en_US.UTF-8/UTF-8-EAW-CONSOLE \' >> ../localedata/SUPPORTED
    ''
    + old.preBuild;
  })
