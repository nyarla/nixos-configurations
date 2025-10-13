{ pkgs, ... }:
{
  # auto-mount for encrypted usb devices with btrfs
  systemd.services.automount-encrypted-usb-device = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "Automount service for encrypted usb storage";
    path = with pkgs; [
      coreutils
      cryptsetup
      "/run/wrappers/bin"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = toString (
        pkgs.writeShellScript "mount.sh" ''
          set -xeuo pipefail

          export PATH=/run/wrappers/bin:$PATH

          mount-if-exists() {
            local deviceId
            deviceId=$1

            if [[ ! -e /dev/disk/by-uuid/$deviceId ]]; then
              echo "/dev/disk/by-uuid/$deviceId is not found."
              exit 0
            fi

            if [[ ! -e /boot/keys/$deviceId ]]; then
              echo "/boot/keys/$deviceId is not found."
              exit 0
            fi

            if [[ ! -e /persist/data/$deviceId ]]; then
              mkdir -p /persist/data/$deviceId
            fi

            if [[ ! -e /dev/mapper/dev-disk-by-uuid-$deviceId ]]; then
              cryptsetup luksOpen \
                --key-file /boot/keys/$deviceId \
                /dev/disk/by-uuid/$deviceId dev-disk-by-uuid-$deviceId
            fi

            if [[ ! -e /persist/data/$deviceId/.keep ]]; then
              mount -t btrfs -o compress=zstd,ssd,space_cache=v2,x-gvfs-hide,noexec,nosuid,nodev \
                /dev/mapper/dev-disk-by-uuid-$deviceId \
                /persist/data/$deviceId
            fi

            return 0
          }

          backup-if-exists() {
            local deviceId
            deviceId=$1

            local dirName
            dirName=$2

            if [[ ! -e /persist/data/$deviceId/$dirName ]]; then
              echo "/persist/data/$deviceId/$dirName is not found."
              exit 0
            fi

            if [[ ! -e /backup/$dirName ]]; then
              mkdir -p /backup/$dirName
            fi

            mount -o bind /persist/data/$deviceId/$dirName /backup/$dirName
            return $?
          }

          mount-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7

          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 Archives
          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 Calibre
          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 Music
          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 Pictures
          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 eBooks

          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 Sources/AI
          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 Sources/Games
          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 Sources/ISO
          backup-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7 Sources/Learn
        ''
      );

      ExecStop = toString (
        pkgs.writeShellScript "unmount.sh" ''
          set -xeuo pipefail

          export PATH=/run/wrappers/bin:$PATH

          unbind-if-exists() {
            local dirName
            dirName=$1

            if [[ -e /backup/$dirName ]]; then
              umount /backup/$dirName
            fi

            return 0
          }

          unmount-if-exists() {
            local deviceId
            deviceId=$1

            if [[ -e /persist/data/$deviceId ]]; then
              umount /persist/data/$deviceId || true
            fi

            if [[ -e /dev/mapper/dev-disk-by-uuid-$deviceId ]]; then
              cryptsetup luksClose /dev/mapper/dev-disk-by-uuid-$deviceId
            fi

            return 0
          }

          unbind-if-exists Archives
          unbind-if-exists Calibre
          unbind-if-exists Music
          unbind-if-exists Pictures
          unbind-if-exists eBooks

          unbind-if-exists Sources/AI
          unbind-if-exists Sources/Games
          unbind-if-exists Sources/ISO
          unbind-if-exists Sources/Learn

          unmount-if-exists 14887bd8-3e3c-4675-9e81-9027a050cdf7

          exit 0
        ''
      );
    };
  };
}
