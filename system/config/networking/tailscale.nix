_: {
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--ssh" ];
  };
}
