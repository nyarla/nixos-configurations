{
  callPackage,

  gitFull,
  nodejs,
}:
callPackage ./wrapper.nix {
  name = "git";
  cmd = "${gitFull}/bin/git";
  settings = {
    extends = "@base";
    filesystem = {
      allowGitConfig = true;
      allowRead = [
        "."
        "~/.config/fence/git.json"
        "~/.config/git"
        "~/.ssh/id_ed25519.pub"

        ".gitignore"
      ];

      allowWrite = [
        ".git"
        "~/.ssh/known_hosts"
        "~/.ssh/known_hosts.old"
      ];

      defaultReadDeny = true;
    };

    network = {
      allowedDomains = [
        "github.com"
        "api.github.com"
        "codeload.github.com"
        "lfs.github.com"
        "objects.githubusercontent.com"

        "gitlab.com"

        "codeberg.org"

        "*.teracloud.jp"
      ];
      allowedUnixSockets = [
        "/run/user/*/gnupg/S.gpg-agent.ssh"
      ];
    };

    ssh = {
      allowAllCommands = true;
      allowedHosts = [
        "github.com"

        "gitlab.com"

        "codeberg.org"
      ];
    };
  };
  extraInit = ''
    export PATH=${gitFull}/bin:${nodejs}/bin:$PATH
    export GIT_SSH_COMMAND='ssh -F /dev/null -o "ProxyCommand=nc -X 5 x 127.0.0.1:1080 %h %p"'
  '';
}
