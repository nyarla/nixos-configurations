{ pkgs, ... }: {
  mod.programs.desktop.enable = true;
  mod.services.desktop.enable = true;

  mod.programs.sandbox.enable = true;

  # sandbox apps
  mod.security.sandbox.settings = {
    user = {
      name = "nyarla";
      group = "users";
      uid = 1000;
      gid = 100;
    };

    locale = {
      LANG = "ja_JP.UTF-8";
      LC_ALL = "ja_JP.UTF-8";
    };

    theme.gtk = "Fluent-Light-compact";
  };

  mod.sandbox.desktop.deadbeef = {
    enable = true;
    library = "/backup/Music";
    package = with pkgs; deadbeef-with-plugins.override { plugins = [ deadbeef-fb ]; };
  };
}
