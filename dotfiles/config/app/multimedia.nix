{ pkgs, ... }: {
  home.packages = with pkgs; [
    audacity
    calibre
    (deadbeef-with-plugins.override {
      plugins = with pkgs; [ deadbeefPlugins.lyricbar deadbeef-fb ];
    })
    glib.out
    picard
    quodlibet-full
  ];
}
