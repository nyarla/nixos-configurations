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

        # android
        "adbusers"

        # gui
        "audio" "video" "render" "disk" "input" "storage" "lightdm"

        # vm
        "kvm" "libvirtd" "vboxusers"
      ];
      home         = "/home/nyarla";
      isNormalUser = true;
      shell        = pkgs.zsh;
    };
  };
}
