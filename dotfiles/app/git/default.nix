{ pkgs, ... }: {
  home.packages = with pkgs; [ rbw lefthook ];
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
        fileMode = false;
        fscache = true;
        preloadindex = true;
        quotepath = false;
      };
      credential.helper = "rbw";
    };
    ignores = import ./gitignore.nix;
  };
}
