{ pkgs, ... }: {
  users.users.nyarla = {
    createHome = true;
    description = "OKAMURA Naoki";
    group = "users";
    extraGroups = [ "wheel" ];
    home = "/home/nyarla";
    isNormalUser = true;
    shell = pkgs.zsh;
  };
}
