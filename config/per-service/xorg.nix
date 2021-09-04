{ config, pkgs, ... }:
let utils = with pkgs; [ xclip xdg_utils libnotify gksu ];
in {
  environment.systemPackages = utils;
  services.dbus.packages = utils;

  console.useXkbConfig = true;

  services.xserver = {
    enable = true;
    autorun = true;
    libinput.enable = true;

    displayManager = {
      job.environment.LANG = "ja_JP.UTF-8";
      lightdm = {
        enable = true;
        greeters = {
          mini = {
            enable = true;
            user = "nyarla";
            extraConfig = ''
              [greeter]
              show-password-label   = true
              show-input-cursor     = true
              password-label-text   = login:

              [greeter-hotkeys]
              mod-key       = control
              shutdown-key  = s
              suspend-key   = p
              hibernate-key = h
              restart-key   = r

              [greeter-theme]
              font              = "Sans"
              font-size         = 1em
              text-color        = "#F9F9F9"
              error-color       = "#FF0000"
              background-image  = ""
              background-color  = "#333333"
              window-color      = "#333333"
              border-color      = "#00CCFF"
              border-width      = 1px
              password-border-color = "#00CCFF"
              password-border-width = 1px
              layout-space      = 30
              password-color            = "#FFFFFF"
              password-background-color = "#333333"
            '';
          };
        };
      };
    };
  };
}
