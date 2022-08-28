{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ clamav ];
  services.clamav.updater.enable = true;
  services.clamav.updater.settings = {
    DatabaseMirror = [ "db.jp.clamav.net" ];
  };
}
