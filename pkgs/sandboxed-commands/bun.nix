{
  callPackage,

  lib,

  bun,
}:
callPackage ./wrapper.nix {
  name = "bun";
  cmd = "${lib.getExe bun}";
  settings = {
    extends = "@base";
    filesystem = {
      allowGitConfig = false;
      allowRead = [
        "."
      ];
      allowWrite = [
        "."
      ];
      allowExecute = [
        "node_modules/.bin"
      ];
      defaultDenyRead = true;
    };
    network = {
      allowedDomains = [ "*" ];
    };
  };
}
