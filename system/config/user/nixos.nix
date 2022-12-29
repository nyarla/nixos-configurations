{ pkgs, ... }: {
  users.users.nixos = {
    home = "/home/nixos";
    group = "users";
    extraGroups = [
      # sudo
      "wheel"

      # terminal
      "tty"

      # desktop
      "audio"
      "lp"
      "scanner"
      "video"

      # hardware
      "disk"
      "input"
      "networkmanager"
      "storage"

      # graphic
      "render"
    ];

    description = "NIXOS";
    createHome = true;
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
