{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fence
    fence-sandboxed
  ];

  xdg.configFile = {
    "fence/fence.json".text = builtins.toJSON {
      allowPty = true;
      filesystem = {
        allowRead = [
          "/nix/"
          "/run/current-system/"
          "/run/current-system/sw/"
        ];

        allowExecute = [
          "/nix/store/"
          "/run/current-system/sw/bin/"
        ];

        allowWrite = [ "/tmp/" ];
      };
      "command" = {
        acceptSharedBinaryCannotRuntimeDeny = [
          "chroot"
          "coreutils"
        ];
      };
    };

    "fence/sgit.json".text =
      let
        allowedHosts = [
          "github.com"
          "gitlab.com"
          "codeberg.org"
        ];

        allowedDomains = allowedHosts ++ [
          "api.github.com"
          "codeload.github.com"
          "lfs.github.com"
          "objects.githubusercontent.com"
        ];
      in
      builtins.toJSON {
        extends = "@base";
        filesystem = {
          allowGitConfig = true;
          allowRead = [
            "~/.config/fence/sgit.json"
            "~/.config/git/"
            "~/.ssh/id_ed25519.pub"
          ];
          allowWrite = [
            ".git"
            "~/.ssh/known_hosts"
            "~/.ssh/known_hosts.old"
          ];
          defaultDenyRead = true;
        };

        network = {
          inherit allowedDomains;
          allowedUnixSockets = [
            "/run/user/*/gnupg/S.gpg-agent.ssh"
          ];
        };

        ssh = {
          inherit allowedHosts;
          allowAllCommands = true;
        };
      };
  };
}
