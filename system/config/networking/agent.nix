{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ aria bind curlFull rclone wget ];
}
