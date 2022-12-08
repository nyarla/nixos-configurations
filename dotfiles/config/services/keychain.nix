_: {
  programs.keychain = {
    enable = false;
    extraFlags = [ "--nogui" "--quiet" ];
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
