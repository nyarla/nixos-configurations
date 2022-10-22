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
        "!f() { git branch -r --merged | grep -vP 'main|master' | cut -d/ -f2 | xargs -I{} git push --delete origin {} }; f";
      cleanup =
        "!f() { git branch --merged | grep -vP 'main|master' | xargs -I{} git branch -d {} }; f";
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
