{ ... }: {
  xdg.configFile."containers/storage.conf".text = ''
    [storage]
    driver = "btrfs"
    graphroot = "/media/data/containers"
    runroot = "$HOME/.cache/containers"
  '';
}
