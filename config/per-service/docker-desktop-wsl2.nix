{ config, pkgs, lib, ... }: {
  imports = [
    ../per-console/container-toolchain.nix
    ../../external/nix-ld/modules/nix-ld.nix
  ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    listenOptions = [ "127.0.0.1:2375" ];
  };

  users.groups.docker.gid = config.ids.gids.docker;

  systemd.sockets.docker-desktop-wsl = {
    description = "Docker Socket for the API by docker-desktop-wsl";
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = "/var/run/docker.sock";
      SocketMode = "0660";
      SocketUser = "root";
      SocketGroup = "docker";
    };
  };

  systemd.services.docker-desktop-wsl = {
    enable = true;
    requires = [ "docker-desktop-wsl.socket" ];
    environment = {
      NIX_LD_LIBRARY_PATH =
        lib.makeLibraryPath config.environment.systemPackages;
      NIX_LD = builtins.readFile "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    };
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      Group = "docker";
      ExecStart = "/bin/sh -c ${
          pkgs.writeScript "docker-desktop-proxy" ''
            #!/bin/sh
            rm /var/run/docker-desktop-proxy.pid
            chmod +x /mnt/wsl/docker-desktop/docker-desktop-proxy
            pid=$(/mnt/wsl/docker-desktop/docker-desktop-proxy --distro-name NixOS --docker-desktop-root /mnt/wsl/docker-desktop --use-cloud-cli=false >/var/log/docker-desktop-wsl.log 2>&1)
            wait $pid
          ''
        }";
    };
  };
}
