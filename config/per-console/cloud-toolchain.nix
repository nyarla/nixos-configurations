{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ awscli nixops google-cloud-sdk ];
}
