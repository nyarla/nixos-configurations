{ pkgs, ... }: {
  home.packages = with pkgs; [ git-credential-keepassxc lefthook ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitFull;
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      prune =
        "!git branch -r --merged | grep -v main | grep -v master | cut -d/ -f2 | xargs -I{} git push --delete origin {}";
      cleanup =
        "!git branch --merged | grep -v main | grep -v master | xargs -I{} git branch -d {}";
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
      credential.helper = "keepassxc";
    };
    ignores = import ./gitignore.nix;
  };
}
