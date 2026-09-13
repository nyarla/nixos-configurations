{
  callPackage,

  lib,

  iconv,
  nodejs,
  pi-coding-agent,
  python3,
}:
let
  PATH = lib.makeBinPath [
    nodejs
    python3
    iconv
  ];
in
callPackage ./wrapper.nix {
  name = "pi";
  cmd = "${pi-coding-agent}/bin/pi";
  settings = {
    extends = "@base";
    filesystem = {
      allowGitConfig = false;
      allowRead = [
        "."
        "~/.pi/secrets/"
      ];
      allowWrite = [
        "."
        "~/.npm"
        "~/.pi/agent/"
      ];
      defaultDenyRead = true;
    };

    network = {
      allowedDomains = [
        "*.anthropic.com"
        "api.ai.sakura.ad.jp"
        "api.openai.com"
        "opencode.ai"

        "127.0.0.1"
        "localhost"

        "*.npmjs.org"
        "registry.npmjs.org"
      ];
      allowLocalOutbound = true;
      allowLocalOutboundPorts = [ 11343 ];
    };
  };

  extraInit = ''
    export PATH=${PATH}:$PATH
  '';
}
