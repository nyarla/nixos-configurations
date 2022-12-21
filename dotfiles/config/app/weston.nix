{ lib, pkgs, ... }: {
  home.packages = with pkgs; [ weston ];

  xdg.configFile."weston.ini".text = lib.generators.toINI { } {
    core = { xwayland = false; };
    libinput = { enable-tap = true; };
    shell = {
      panel-position = "none";
      locking = false;
    };
    output = {
      name = "screen0";
      mode = "1920x1032";
    };
  };
}
