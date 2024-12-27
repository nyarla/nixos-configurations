{ lib }:
let
  inherit (import ../../config/vars/xml.nix { inherit lib; })
    tag2
    el2
    el3
    ;

  p = name: contains: el2 name (if builtins.isList contains then contains else [ contains ]);
  a = name: attrs: tag2 name attrs;

  font =
    place:
    { name, size }:
    el3 "font" { inherit place; } [
      (p "name" name)
      (p "size" size)
    ];

  keybind = key: actions: el3 "keybind" { inherit key; } actions;
  mousebind =
    button: action: actions:
    el3 "mousebind" { inherit button action; } actions;

  run =
    commandline:
    el3 "action" { name = "Execute"; } [
      (el2 "command" [ commandline ])
    ];

  action =
    name: contains:
    if (builtins.length contains) == 0 then
      el2 "action" { inherit name; }
    else
      el3 "action" { inherit name; } contains;
in
''
  <?xml version="1.0" ?>
''
+ (p "labwc_config" [
  (p "core" [
    (p "decoration" "server")
    (p "gap" "0")
    (p "adaptiveSync" "no")
    (p "reuseOutputMode" "no")
  ])

  (p "focus" [
    (p "followMouse" "no")
    (p "raiseOnFocus" "no")
  ])

  (p "theme" [
    (p "name" "Kaunas")
    (p "cornerRadius" "0")
    (font "ActiveWindow" {
      name = "sans";
      size = "9";
    })
    (font "MenuItem" {
      name = "sans";
      size = "10";
    })
    (font "OSD" {
      name = "sans";
      size = "9";
    })
  ])

  (p "regions" [
    (a "region" {
      name = "center";
      x = "25%";
      y = "25%";
      width = "50%";
      height = "50%";
    })
  ])

  (p "snapping" [
    (p "range" "1")
    (p "topMaximize" "yes")
  ])
  (p "resistance" [ (p "screenEdgeStrength" "20") ])

  (p "keyboard" [
    (keybind "A-Left" [ (action "SnapToEdge" [ (p "direction" "left") ]) ])
    (keybind "A-Right" [ (action "SnapToEdge" [ (p "direction" "right") ]) ])
    (keybind "A-Up" [ (action "SnapToEdge" [ (p "direction" "up") ]) ])
    (keybind "A-Down" [ (action "SnapToEdge" [ (p "direction" "down") ]) ])

    (keybind "A-o" [ (action "SnapToRegion" [ (p "region" "center") ]) ])

    (keybind "A-F1" [ (action "ShowMenu" [ (p "menu" "root-menu") ]) ])
    (keybind "A-F2" [ (action "ShowMenu" [ (p "menu" "applications-creative") ]) ])
    (keybind "C-W-q" [ (run "swaylock -C ~/.config/swaylock/config -f") ])

    (keybind "S-Print" [ (run "gyazo screenshot") ])
    (keybind "C-Print" [ (run "gyazo capture") ])
  ])
])
