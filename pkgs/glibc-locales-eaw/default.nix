{
  glibcLocales,
  fetchurl,
  allLocales ? true,
  locales ? [ "en_US.UTF-8/UTF-8" ],
}:

let
  UTF-8-EAW-CONSOLE = fetchurl {
    url = "https://github.com/hamano/locale-eaw/raw/7623d45f9b87d9b44dca6ef8c46fc97b22690f50/dist/UTF-8-EAW-CONSOLE";
    sha256 = "1jm54m7abyc0fvvavr2qilrbiilcp8fz5k9d4fp6pdqpq87k9irv";
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
