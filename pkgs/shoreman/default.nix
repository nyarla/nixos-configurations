{
  fetchurl,
  bash,
  runCommand,
}:
let
  shoreman = fetchurl {
    url = "https://raw.githubusercontent.com/chrismytton/shoreman/master/shoreman.sh";
    sha256 = "05xqmmwx97y1fh67xgaal1zrsfzxpadllkh9cm2mkf1b0ziwq6m2";
  };
in
runCommand "shoreman" { } ''
  mkdir -p $out/bin
  echo '#!${bash}/bin/bash'             >>$out/bin/shoreman
  echo 'export PATH=${bash}/bin:$PATH'  >>$out/bin/shoreman
  cat  ${shoreman}                      >>$out/bin/shoreman

  chmod +x $out/bin/shoreman
''
