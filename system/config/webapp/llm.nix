_: {
  services.ollama = {
    enable = true;
    home = "/var/lib/ollama";
    writablePaths = [ "/var/lib/ollama" ];
    acceleration = "cuda";
  };
}
