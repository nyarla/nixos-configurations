_: {
  programs.keychain = {
    enable = true;
    extraFlags = [ "--nogui" "--quiet" ];
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
