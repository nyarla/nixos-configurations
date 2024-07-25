{ pkgs, config, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    package = pkgs.gitFull;
    aliases = {
      co = "checkout";
      ci = "commit";
      force-push = "push -f --force-with-lease --force-if-includes";
      st = "status";
      cleanup = "!git branch --merged | grep -v main | grep -v master | xargs -I{} git branch -d {}";
    };
    extraConfig = {
      color = {
        ui = true;
      };
      init = {
        defaultBranch = "main";
      };
      core = {
        autoCRLF = false;
        fileMode = false;
        fscache = true;
        preloadindex = true;
        quotepath = false;
        hooksPath = "${config.home.homeDirectory}/Applications/Development/githooks/hooks";
      };
      credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
    };
    ignores = import ./gitignore.nix;
  };
}
