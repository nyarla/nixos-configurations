{ pkgs, ... }:
{
  users.mutableUsers = false;
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

      # virtualbox
      "vboxusers"

      # vmm
      "kvm"
      # "libvirtd"
    ];

    description = "OKAMURA Naoki";
    createHome = true;
    isNormalUser = true;
    shell = pkgs.zsh;
    initialHashedPassword = "$6$lABardu7BNX7a5cv$8TIACJK2U.GBjdsSnFpPHEiwkMtPSCZrxQsphf9uadpu3tBqKfgdZCSW.b2PyJXw16dzgvBysUzknPZ99kxec0";
  };

  programs.zsh.enable = true;
}
