_: {
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "us";
    model = "pc104";
    options = "ctrl:nocaps";
  };
}
