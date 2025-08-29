{
  kdePackages,
  writeShellScriptBin,
}:
writeShellScriptBin "xembedsniproxy" ''
  exec -a xembed-sni-proxy ${kdePackages.plasma-workspace}/bin/xembedsniproxy "''${@:-}"
''
