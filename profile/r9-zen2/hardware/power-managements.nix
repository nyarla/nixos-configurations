{ config, ... }: {
  services.upower.enable = config.powerManagement.enable;
}
