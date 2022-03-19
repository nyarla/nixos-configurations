{ pkgs, ... }: { users.users.nyarla.extraGroups = [ "docker" "plugdev" ]; }
