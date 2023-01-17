{ pkgs, ... }: {
  home.packages = with pkgs; [
    audacity
    calibre
    (deadbeef-with-plugins.override {
      plugins = with pkgs; [ deadbeefPlugins.lyricbar deadbeef-fb ];
    })
    foliate
    glib.out
    jack2
    picard
    qjackctl
    quodlibet-full
  ];
}
