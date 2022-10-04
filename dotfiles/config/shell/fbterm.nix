{ lib, ... }:
let toKV = lib.generators.toKeyValue { };
in {
  xdg.configFile."fbterm/fbtermrc".text = toKV {
    font-names = "monospace";
    font-size = 14;
    font-width = 7;
    font-height = 17;

    color-0 = "000000";
    colro-1 = "ff6633";
    color-2 = "ccff00";
    color-3 = "ffcc33";
    color-4 = "00ccff";
    color-5 = "cc99cc";
    color-6 = "00cccc";
    color-7 = "ffffff";

    color-8 = "333333";
    colro-9 = "ff6633";
    color-10 = "ccff00";
    color-11 = "ffcc33";
    color-12 = "00ccff";
    color-13 = "cc99cc";
    color-14 = "00cccc";
    color-15 = "ffffff";

    color-foreground = 7;
    color-background = 0;

    history-lines = 1000;

    text-encodings = "UTF-8";

    cursor-shape = 0;
    cursor-interval = 500;

    word-chars = "._-";

    screen-rotate = 0;

    input-method = "fcitx5-fbterm";

    ambiguous-wide = "yes";
  };
}
