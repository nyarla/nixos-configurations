_: {
  services.ollama = {
    enable = false;
    home = "/var/lib/ollama";
    writablePaths = [ "/var/lib/ollama" ];
  };
}
