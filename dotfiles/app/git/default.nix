{ pkgs, ... }: {
  home.packages = with pkgs; [ git-credential-1password lefthook ];
  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitFull;
    aliases = {
      co = "checkout";
      ci = "commit";
      force-push = "push -f --force-with-lease --force-if-includes";
      st = "status";
      purge =
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
        hooksPath = "/media/data/executable/githooks-v2/hooks";
      };
      credential.helper = "1password -v Development";
    };
    ignores = import ./gitignore.nix;
  };
}
