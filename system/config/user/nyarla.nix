{ pkgs, ... }: {
  users.users.nyarla = {
    home = "/home/nyarla";
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

      # development
      "docker"
      "plugdev"

      # vmm
      "kvm"
      "libvirtd"
    ];

    description = "OKAMURA Naoki";
    createHome = true;
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
