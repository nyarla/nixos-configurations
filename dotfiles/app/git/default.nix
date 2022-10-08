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
      prune =
        "!git branch -r --merged | grep -vP 'main|master' | cut -d/ -f2 | xargs -I{} git push --delete origin {}";
      clean =
        "!git branch --merged | grep -vP 'main|master' | xargs -I{} git branch -d {}";
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
