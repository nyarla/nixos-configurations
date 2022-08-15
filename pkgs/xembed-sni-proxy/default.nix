{ libsForQt5, runCommand }:
runCommand "xembed-sni-proxy" { } ''
  mkdir -p $out/bin
  cp ${libsForQt5.plasma-workspace.out}/bin/xembedsniproxy $out/bin/xembedsniproxy
  chmod +x $out/bin/*
''
