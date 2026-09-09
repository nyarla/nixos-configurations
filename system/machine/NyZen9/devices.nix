{ pkgs, ... }:
{
  # auto-mount for Windows 11 Pro system device
  systemd.services.automount-windows-11-pro = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "Auto-mount service for Windows 11 Pro volume";
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

            if [[ ! -e /persist/data/$deviceId/Files ]]; then
              mount -t ntfs3 -o ro,dmask=022,fmask=033,uid=1000,gid=100,x-gvfs-hide \
                /dev/disk/by-uuid/$deviceId \
                /persist/data/$deviceId
            fi

            return 0
          }

          bind-if-exists() {
            local deviceId
            local dir

            deviceId=$1
            dir=$2

            if [[ ! -e /persist/data/$deviceId/$dir ]]; then
              echo "bind source is not found."
              exit 0
            fi

            if [[ ! -e /backup/Windows/$dir ]]; then
              mkdir -p /backup/Windows/$dir
            fi

            mount --bind /persist/data/$deviceId/$dir /backup/Windows/$dir
          }

          mount-if-exists 4E2210AF22109E51

          bind-if-exists  4E2210AF22109E51  Applications/FLStudio
          bind-if-exists  4E2210AF22109E51  Applications/Maintenance
          bind-if-exists  4E2210AF22109E51  Files/Data
          bind-if-exists  4E2210AF22109E51  Files/Source
          bind-if-exists  4E2210AF22109E51  Users/nyarla/Documents
        ''
      );

      ExecStop = toString (
        pkgs.writeShellScript "umount.sh" ''
          set -xeuo pipefail

          export PATH=/run/wrappers/bin:$PATH

          unmount-if-exists() {
            local deviceId
            deviceId=$1

            if [[ -e /persist/data/$deviceId ]]; then
              umount /persist/data/$deviceId || true
            fi

            return 0
          }

          unbind-if-exists() {
            local dir=$1

            if [[ -e /backup/Windows/$dir ]]; then
              umount /backup/Windows/$dir || true;
            fi
          }

          unbind-if-exists Applications/FLStudio
          unbind-if-exists Applications/Maintenance
          unbind-if-exists Files/Data
          unbind-if-exists Files/Source
          unbind-if-exists Users/nyarla/Documents

          unmount-if-exists 4E2210AF22109E51
        ''
      );
    };
  };

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

          mount-if-exists DBF4-42B3
        ''
      );

      ExecStop = toString (
        pkgs.writeShellScript "unmount.sh" ''
          set -xeuo pipefail

          export PATH=/run/wrappers/bin:$PATH

          unmount-if-exists() {
            local deviceId
            deviceId=$1

            if [[ -e /persist/data/$deviceId ]]; then
              umount /persist/data/$deviceId || true
            fi

            return 0
          }

          unmount-if-exists DBF4-42B3

          exit 0
        ''
      );
    };
  };
}
