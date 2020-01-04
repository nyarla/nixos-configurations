{ pkgs, ... }:
{
  users.users = {
    nyarla = {
      createHome   = true;
      description  = "Naoki OKAMURA";
      group        = "users";
      extraGroups  = [
        # basic
        "wheel" "docker"

        # gui
        "audio" "video" "render" "disk" "input" "storage" "lightdm"

        # vm
        "kvm" "libvirtd"
      ];
      home         = "/home/nyarla";
      isNormalUser = true;
      shell        = pkgs.zsh;
    };
  };
}
