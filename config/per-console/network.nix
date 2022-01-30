{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ curlFull wget bind ];
}
