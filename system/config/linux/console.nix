{ pkgs, ... }: {
  console.colors = [
    "000000"
    "FF6633"
    "CCFF00"
    "FFCC33"
    "00CCFF"
    "CC99CC"
    "00CCCC"
    "F9F9F9"
    "666666"
    "FF6633"
    "CCFF00"
    "FFCC33"
    "00CCFF"
    "CC99CC"
    "00CCCC"
    "FFFFFF"
  ];

  console.earlySetup = true;

  environment.systemPackages = with pkgs; [ fbterm ];

  security.wrappers = {
    fbterm = {
      owner = "root";
      group = "wheel";
      source = "${pkgs.fbterm}/bin/fbterm";
      capabilities = "cap_sys_tty_config+ep";
    };
  };
}
