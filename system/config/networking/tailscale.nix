{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ tailscale ];
  services.tailscale.enable = true;

  systemd.services.tailscale-autoconnect = {
    description = "Auto-connect to tailscale";
    after = [ "network-pre.target" "tailscaled.service" ];
    wants = [ "network-pre.target" "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = { Type = "oneshot"; };
    script = with pkgs; ''
      TRIES=0
      until ${tailscale}/bin/tailscale up ; do
        sleep 0.1
        let TRIES+=1

        test $TRIES = 20 && break
      done
    '';
  };
}
