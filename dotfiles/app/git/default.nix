{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
    };
    extraConfig = {
      color = { ui = true; };
      init = { defaultBranch = "main"; };
      core = {
        autoCRLF = false;
        editor = "nvr --remote-wait-silent";
        fileMode = false;
        fscache = true;
        hooksPath = "/home/nyarla/local/githooks/hooks";
        preloadindex = true;
        quotepath = false;
      };
    };
    ignores = import ./gitignore.nix;
  };
}
