{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ tailscale ];
  services.tailscale.enable = true;

  systemd.services.tailscale-autoconnect = {
    description = "Auto-connect to tailscale";
    after = [ "network-pre.target" "tailscaled.service" ];
    wants = [ "network-pre.target" "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = { Type = "oneshot"; };
    script = with pkgs; ''
      sleep 2

      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if test $status = "Running" ; then
        exit 0
      fi

      ${tailscale}/bin/tailscale up 
    '';
  };
}
