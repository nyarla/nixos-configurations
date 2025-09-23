{ pkgs, ... }:
{
  # clock setting for dual boot to windows
  time.hardwareClockInLocalTime = true;

  # pc fan control
  systemd.services.fan2go =
    let
      config = pkgs.writeText "fan2go.yaml" (
        let
          fan = id: curve: index: {
            inherit id;
            inherit curve;
            hwmon = {
              platform = "nct6798";
              rpmChannel = index;
              pwmChannel = index;
            };
          };

          sensor = id: platform: index: {
            inherit id;
            hwmon = {
              inherit platform;
              inherit index;
            };
          };

          curve = id: sensor: steps: {
            inherit id;
            linear = {
              inherit sensor;
              inherit steps;
            };
          };
        in
        builtins.toJSON {
          dbPath = "/var/lib/fan2go/fan.db";

          fans = [
            (fan "cpu" "cpu" 2)
            (fan "case" "case" 1)
            (fan "back" "cpu" 7)
          ];
          sensors = [
            (sensor "cpu" "k10temp" 1)
            (sensor "nvme-pci-0100" "nvme-pci-0100" 1)
            (sensor "nvme-pci-0800" "nvme-pci-0800" 1)
          ];
          curves = [
            (curve "cpu" "cpu" {
              "30" = 15;
              "70" = 255;
            })
            (curve "nvme-pci-0100" "nvme-pci-0100" {
              "30" = 100;
              "65" = 255;
            })
            (curve "nvme-pci-0800" "nvme-pci-0800" {
              "30" = 100;
              "65" = 255;
            })
            {
              id = "case";
              function = {
                type = "average";
                curves = [
                  "cpu"
                  "nvme-pci-0100"
                  "nvme-pci-0800"
                ];
              };
            }
          ];
        }
      );
    in
    {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "lm_sensors.service" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.fan2go}/bin/fan2go -c ${config}";
        ExecStartPre = "${pkgs.fan2go}/bin/fan2go -c ${config} config validate";
        Restart = "always";
      };
    };

  powerManagement.resumeCommands = ''
    systemctl restart fan2go.service
  '';
}
