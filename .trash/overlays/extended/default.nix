self: super:
let require = path: args: super.callPackage (import path) args;
in {
  deezer = require ./pkgs/deezer/default.nix { };
  deno-land = require ./pkgs/deno-land/default.nix { };
  dexed = require ./pkgs/dexed/default.nix { };
  elementary-tweaks = require ./pkgs/elementary-tweaks/default.nix { };
  fontmerger = require ./pkgs/font-merger/default.nix { };
  forked-daapd = require ./pkgs/forked-daapd/default.nix { };
  genjyuu-gothic = require ./pkgs/genjyuu-gothic/default.nix { };
  ime-mode-we = require ./pkgs/ime-mode-we/default.nix { };
  jackass = require ./pkgs/jackass/default.nix { };
  linvst-x = require ./pkgs/linvst-x/default.nix { };
  linvst = require ./pkgs/linvst/default.nix { };
  linvst3 = require ./pkgs/linvst3/default.nix { };
  myrica-patched = require ./pkgs/myrica-patched/default.nix { };
  nerdfonts-symbols = require ./pkgs/nerdfonts-symbols/default.nix { };
  newaita-icons = require ./pkgs/newaita-icons/default.nix { };
  noto-fonts-jp = require ./pkgs/noto-fonts-jp/default.nix { };
  pbzx = require ./pkgs/pbzx/default.nix { };
  plastik-theme = require ./pkgs/plastik-theme/default.nix { };
  surge-synthesizer = require ./pkgs/surge-synthesizer/default.nix { };
  switchboard-plug-locale =
    require ./pkgs/switchboard-plug-locale/default.nix { };
  tateditor = require ./pkgs/tateditor/default.nix { };
  violin = require ./pkgs/violin/default.nix { };
  tmux-up = require ./pkgs/tmux-up/default.nix { };
  vst-bridge = require ./pkgs/vst-bridge/default.nix { };
  wcwidth-cjk = require ./pkgs/wcwidth-cjk/default.nix { };
  wineasio = require ./pkgs/wineasio/default.nix { };
  yabridge = require ./pkgs/yabridge/default.nix { };
}
