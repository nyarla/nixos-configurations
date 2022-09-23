{ pkgs, ... }: {
  home.packages = with pkgs; [ rbw ];
  programs.git = {
    enable = true;
    lfs.enable = true;
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
      credential.helper = "rbw";
    };
    ignores = import ./gitignore.nix;
  };
}
