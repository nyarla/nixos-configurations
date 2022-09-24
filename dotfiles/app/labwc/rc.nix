_:
let
  props = tag: contains: ''
    <${tag}>
      ${builtins.concatStringsSep "\n" contains}
    </${tag}>
  '';

  prop = tag: value: "<${tag}>${value}</${tag}>";

  font = place:
    { name, size }: ''
      <font place="${place}">
        <name>${name}</name>
        <size>${size}</size>
      </font>
    '';

  keybind = key: actions: ''
    <keybind key="${key}">
      ${builtins.concatStringsSep "\n" actions}
    </keybind>
  '';

  mousebind = button: action: contains: ''
    <mousebind button="${button}" action="${action}">
      ${builtins.concatStringsSep "\n" contains}
    </mousebind>
  '';

  exec = command: ''
    <action name="Execute">
      <command>${command}</command>
    </action>
  '';

  action = name: contains:
    if (builtins.length contains) == 0 then
      ''<action name="${name}" />''
    else ''
      <action name="${name}">${builtins.concatStringsSep "\n" contains}</action>
    '';

in ''
  <?xml version="1.0" ?>
'' + (props "labwc_config" [
  (props "core" [
    (prop "decoration" "server")
    (prop "gap" "0")
    (prop "adaptiveSync" "no")
  ])

  (props "focus" [ (prop "followMouse" "yes") (prop "raiseOnFocus" "no") ])

  (props "theme" [
    (prop "name" "Arc-Dark")
    (prop "cornerRadius" "0")
    (font "ActiveWindow" {
      name = "sans";
      size = "9";
    })
    (font "MenuItem" {
      name = "sans";
      size = "9";
    })
    (font "OSD" {
      name = "sans";
      size = "9";
    })
  ])

  (props "snapping" [ (prop "range" "1") (prop "topMaximize" "yes") ])

  (props "resistance" [ (prop "screenEdgeStrength" "20") ])

  (props "keyboard" [
    (keybind "A-Left" [ (action "SnapToEdge" [ (prop "direction" "left") ]) ])
    (keybind "A-Right" [ (action "SnapToEdge" [ (prop "direction" "right") ]) ])
    (keybind "A-Up" [ (action "SnapToEdge" [ (prop "direction" "up") ]) ])
    (keybind "A-Down" [ (action "SnapToEdge" [ (prop "direction" "down") ]) ])

    (keybind "A-m" [ (action "ShowMenu" [ (prop "menu" "root-menu") ]) ])
    (keybind "C-W-q" [ (exec "swaylock -f") ])

    (keybind "XF86_AudioPlay" [ (exec "mpc toggle") ])
  ])
])
