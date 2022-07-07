{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "nyarla";
    userEmail = "nyarla@kalaclista.com";
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
    };
    extraConfig = {
      color = { ui = true; };
      init = { defaultBranch = "main"; };
      core = {
        fileMode = false;
        preloadindex = true;
        fscache = true;
        autoCRLF = false;
        quotepath = false;
        hooksPath = "/home/nyarla/local/githooks/hooks";
      };
    };
    ignores = import ./gitignore.nix;
  };
}
