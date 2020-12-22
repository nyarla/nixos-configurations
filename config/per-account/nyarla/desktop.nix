{ pkgs, ... }: {
  users.users.nyarla.extraGroups =
    [ "audio" "video" "render" "disk" "input" "storage" "lightdm" ];
}
