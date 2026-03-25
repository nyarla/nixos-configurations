{ pkgs, ... }:
{
  # auto-mount for exfat-formatted usb device
  systemd.services.automount-usb-exfat-adata = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "Automount service for usb storage";
    path = with pkgs; [
      coreutils
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

            if [[ ! -e /persist/data/$deviceId ]]; then
              mkdir -p /persist/data/$deviceId
            fi

            if [[ ! -e /persist/data/$deviceId/.keep ]]; then
              mount -t exfat -o dmask=022,fmask=033,uid=1000,gid=100,x-gvfs-hide \
                /dev/disk/by-uuid/$deviceId \
                /persist/data/$deviceId
            fi

            return 0
          }

          backup-if-exists() {
            local deviceId
            deviceId=$1

            local src
            src=$2

            local dest
            dest=$3

            if [[ ! -e /persist/data/$deviceId/$src ]]; then
              echo "/persist/data/$deviceId/$src is not found."
              exit 0
            fi

            if [[ ! -e /backup/$dest ]]; then
              mkdir -p /backup/$dest
            fi

            mount -o bind /persist/data/$deviceId/$src /backup/$dest
            return $?
          }

          mount-if-exists DBF4-42B3

          backup-if-exists DBF4-42B3 Source Sources/DAW
          backup-if-exists DBF4-42B3 Data Documents/DAW
          backup-if-exists DBF4-42B3 Model Documents/Model
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

            return 0
          }

          unbind-if-exists Sources/DAW
          unbind-if-exists Documents/DAW
          unbind-if-exists Documents/Model

          unmount-if-exists DBF4-42B3

          exit 0
        ''
      );
    };
  };
}
