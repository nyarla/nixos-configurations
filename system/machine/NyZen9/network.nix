_: {
  # mtu
  networking.interfaces."wlan0".mtu = 1472;

  # avahi
  services.avahi.allowInterfaces = [ "wlan0" ];

  # samba
  services.samba = {
    enable = true;
    nmbd.enable = true;
    winbindd.enable = true;
    settings = {
      global = {
        "security" = "user";
        "workgroup" = "WORKGROUP";
        "server string" = "nixos";
        "netbios name" = "nixos";
        "use sendfile" = "yes";
        "hosts allow" = "192.168.122.0/24 100.126.27.87/32 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
        "acl allow execute always" = "yes";
      };

      Downloads = {
        path = "/persist/home/nyarla/Downloads/KVM";
        browsable = "yes";
        "create mask" = "0774";
        "force create mask" = "0774";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "false";
        "read only" = "no";
      };

      Data = {
        path = "/persist/home/nyarla/Documents/DAW";
        "create mask" = "0774";
        "force create mask" = "0774";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "false";
        "read only" = "no";
      };

      Sources = {
        path = "/persist/home/nyarla/Sources/DAW";
        browsable = "yes";
        "create mask" = "0774";
        "force create mask" = "0774";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "false";
        "read only" = "no";
      };

      Sync = {
        path = "/persist/home/nyarla/Sync";
        browsable = "yes";
        "create mask" = "0774";
        "force create mask" = "0774";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "false";
        "read only" = "no";
      };

      eBook = {
        path = "/backup/eBooks";
        browsable = "yes";
        "create mask" = "0774";
        "force create mask" = "0774";
        "directory mask" = "0755";
        "force group" = "users";
        "force user" = "nyarla";
        "guest ok" = "false";
        "read only" = "yes";
      };
    };
  };
}
