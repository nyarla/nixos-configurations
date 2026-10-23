_: {
  mod.security.clamav = {
    enable = true;
    schedule = "*-*-* 03:00:00";
    logFile = "/persist/home/nyarla/Reports/clamav.log";
    maxThreads = 30;
    excludes = [
      # system directories
      ".snapshots/[0-9]"

      "^/dev"
      "^/nix"
      "^/proc"
      "^/run"
      "^/sys"

      # vm storage pool
      "^/vm"

      # these directories have the same files in `/persist`
      "^/home/nyarla"
      "^/backup"

      "^/persist/home/nyarla/Reports"
    ];
  };

}
