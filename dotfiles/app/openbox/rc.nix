_:
let
  props = tag: contains: ''
    <${tag}>
      ${builtins.concatStringsSep "\n" contains}
    </${tag}>
  '';

  prop = tag: value: "<${tag}>${value}</${tag}>";

  context = name: contains: ''
    <context name="${name}">
      ${builtins.concatStringsSep "\n" contains}
    </context>
  '';

  font = place:
    { name, size, weight, slant }: ''
      <font place="${place}">
        <name>${name}</name>
        <size>${size}</size>
        <weight>${weight}</weight>
        <slant>${slant}</slant>
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

  join = builtins.concatStringsSep "\n";
in ''
  <?xml version="1.0" encoding="UTF-8" ?>
  <openbox_config
    xmlns="http://openbox.org/3.4/rc"
    xmlns:xi="http://www.w3.org/2001/XInclude">
    ${
      join [
        (props "resistance" [
          (prop "strength" "10")
          (prop "screen_edge_strength" "20")
        ])

        (props "focus" [
          (prop "focusDelay" "200")
          (prop "focusLast" "yes")
          (prop "focusNew" "yes")
          (prop "followMouse" "no")
          (prop "raiseOnFocus" "no")
          (prop "underMouse" "no")
        ])

        (props "placement" [
          (prop "center" "yes")
          (prop "monitor" "Primary")
          (prop "policy" "Smart")
          (prop "primaryMonitor" "1")
        ])

        (props "theme" [
          (prop "name" "Kaunas")
          (prop "titleLayout" "NLIMC")
          (prop "keepBorder" "yes")
          (prop "animateIconify" "yes")

          (font "ActiveWindow" {
            name = "Sans";
            size = "9";
            weight = "Bold";
            slant = "Normal";
          })
          (font "InactiveWindow" {
            name = "Sans";
            size = "9";
            weight = "Bold";
            slant = "Normal";
          })
          (font "MenuHeader" {
            name = "Sans";
            size = "9";
            weight = "Normal";
            slant = "Normal";
          })
          (font "MenuItem" {
            name = "Sans";
            size = "10";
            weight = "Normal";
            slant = "Normal";
          })
          (font "ActiveOnScreenDisplay" {
            name = "Sans";
            size = "9";
            weight = "Bold";
            slant = "Normal";
          })
          (font "InactiveOnScreenDisplay" {
            name = "Sans";
            size = "9";
            weight = "Bold";
            slant = "Normal";
          })
        ])

        (props "desktops" [
          (prop "number" "1")
          (prop "firstdesk" "1")
          (props "names" [ (prop "name" "Home") ])
          (prop "popupTime" "875")
        ])

        (props "resize" [
          (prop "drawContents" "yes")
          (prop "popupShow" "NonPixel")
          (prop "popupPosition" "Center")
          (props "popupFixedPosition" [ (prop "x" "10") (prop "y" "10") ])
        ])

        (props "margins" [
          (prop "top" "0")
          (prop "bottom" "0")
          (prop "left" "0")
          (prop "right" "0")
        ])

        (props "dock" [
          (prop "position" "Top")
          (prop "floatingX" "0")
          (prop "floatingY" "0")
          (prop "noStrut" "no")
          (prop "stacking" "Normal")
          (prop "direction" "Horizontal")
          (prop "autoHide" "no")
          (prop "hideDelay" "300")
          (prop "showDelay" "300")
          (prop "moveButton" "Middle")
        ])

        (props "keyboard" [
          (prop "chainQuitKey" "C-c")

          (keybind "A-F1" [ (action "ShowMenu" [ (prop "menu" "root-menu") ]) ])
          (keybind "A-F2" [ (action "ShowMenu" [ (prop "menu" "applications-creative") ]) ])

          (keybind "C-W-q" [ (exec "xset dpms force off") ])

          (keybind "A-Left" [
            (action "UnmaximizeFull" [ ])
            (action "MoveResizeTo" [
              (prop "x" "0")
              (prop "y" "0")
              (prop "height" "100%")
              (prop "width" "50%")
            ])
          ])
          (keybind "A-Right" [
            (action "UnmaximizeFull" [ ])
            (action "MoveResizeTo" [
              (prop "x" "-0")
              (prop "y" "0")
              (prop "height" "100%")
              (prop "width" "50%")
            ])
          ])
          (keybind "A-Up" [
            (action "UnmaximizeFull" [ ])
            (action "MoveResizeTo" [
              (prop "x" "0")
              (prop "y" "0")
              (prop "height" "50%")
              (prop "width" "100%")
            ])
          ])
          (keybind "A-Down" [
            (action "UnmaximizeFull" [ ])
            (action "MoveResizeTo" [
              (prop "x" "0")
              (prop "y" "-0")
              (prop "height" "50%")
              (prop "width" "100%")
            ])
          ])

          (keybind "A-o" [
            (action "UnmaximizeFull" [ ])
            (action "MoveResizeTo" [
              (prop "x" "center")
              (prop "y" "center")
              (prop "width" "50%")
              (prop "height" "50%")
            ])
          ])
        ])

        (props "mouse" [
          (prop "dragThreshold" "3")
          (prop "doubleClickTime" "500")
          (prop "screenEdgeWrapTime" "400")
          (prop "screenEdgeWrapMouse" "false")
          (context "Titlebar" [
            (mousebind "Left" "Drag" [ (action "Move" [ ]) ])
            (mousebind "Left" "DoubleClick"
              [ (action "ToggleMaximizeFull" [ ]) ])
            (mousebind "Up" "Click" [
              (action "if" [
                (prop "shaded" "no")
                (props "then" [
                  (action "Shade" [ ])
                  (action "FocusToBottom" [ ])
                  (action "UnFocus" [ ])
                  (action "Lower" [ ])
                ])
              ])
            ])
            (mousebind "Down" "Click" [
              (action "if" [
                (prop "shaded" "yes")
                (props "then" [ (action "Unshade" [ ]) (action "Raise" [ ]) ])
              ])
            ])
          ])
          (context
            "Titlebar Top Right Bottom Left TLCorner TRCorner BRCorner BLCorner" [
              (mousebind "Left" "Press" [
                (action "Focus" [ ])
                (action "Raise" [ ])
                (action "Unshade" [ ])
              ])
              (mousebind "Middle" "Press" [
                (action "Lower" [ ])
                (action "FocusToBottom" [ ])
                (action "UnFocus" [ ])
              ])
              (mousebind "Right" "Press" [
                (action "Focus" [ ])
                (action "Raise" [ ])
                (action "ShowMenu" [ (prop "menu" "client-menu") ])
              ])
            ])
          (context "Frame" [
            (mousebind "Alt-Left" "Drag" [ (action "Move" [ ]) ])
            (mousebind "Alt-Right" "Drag" [ (action "Resize" [ ]) ])
          ])

          (context "Top" [
            (mousebind "Left" "Drag"
              [ (action "Raise" [ (prop "edge" "top") ]) ])
          ])
          (context "Left" [
            (mousebind "Left" "Drag"
              [ (action "Raise" [ (prop "edge" "left") ]) ])
          ])
          (context "Right" [
            (mousebind "Left" "Drag"
              [ (action "Raise" [ (prop "edge" "right") ]) ])
          ])
          (context "Bottom" [
            (mousebind "Left" "Drag"
              [ (action "Raise" [ (prop "edge" "bottom") ]) ])
            (mousebind "Right" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
              (action "ShowMenu" [ (prop "menu" "client-menu") ])
            ])
          ])

          (context "TRCorner BRCorner TLCorner BLCorner" [
            (mousebind "Left" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
              (action "Unshade" [ ])
            ])
            (mousebind "Left" "Drag" [ (action "Resize" [ ]) ])
          ])

          (context "Client" [
            (mousebind "Left" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
            ])
            (mousebind "Middle" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
            ])
            (mousebind "Right" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
            ])
          ])

          (context "Icon" [
            (mousebind "Left" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
              (action "Unshade" [ ])
              (action "ShowMenu" [ (prop "menu" "client-menu") ])
            ])
            (mousebind "Right" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
              (action "ShowMenu" [ (prop "menu" "client-menu") ])
            ])
          ])

          (context "AllDesktops" [
            (mousebind "Left" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
              (action "Unshade" [ ])
            ])

            (mousebind "Left" "Click" [ (action "ToggleOmnipresent" [ ]) ])
          ])

          (context "Shade" [
            (mousebind "Left" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
            ])

            (mousebind "Left" "Click" [ (action "ToggleShade" [ ]) ])
          ])

          (context "Iconify" [
            (mousebind "Left" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
            ])

            (mousebind "Left" "Click" [ (action "Iconify" [ ]) ])
          ])

          (context "Maximize" [
            (mousebind "Left" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
              (action "Unshade" [ ])
            ])
            (mousebind "Middle" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
              (action "Unshade" [ ])
            ])
            (mousebind "Right" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
              (action "Unshade" [ ])
            ])
            (mousebind "Left" "Click" [ (action "ToggleMaximize" [ ]) ])
            (mousebind "Middle" "Click"
              [ (action "ToggleMaximize" [ (prop "direction" "vertical") ]) ])
            (mousebind "Right" "Click"
              [ (action "ToggleMaximize" [ (prop "direction" "horizontal") ]) ])
          ])

          (context "Close" [
            (mousebind "Left" "Press" [
              (action "Focus" [ ])
              (action "Raise" [ ])
              (action "Unshade" [ ])
            ])
            (mousebind "Left" "Click" [ (action "Close" [ ]) ])
          ])

          (context "Root" [
            (mousebind "Middle" "Press" [
              (action "ShowMenu" [ (prop "menu" "client-list-combinde-menu") ])
            ])
            (mousebind "Right" "Press"
              [ (action "ShowMenu" [ (prop "menu" "root-menu") ]) ])
          ])
        ])

        (props "menu" [
          (prop "file" "menu.xml")
          (prop "hideDelay" "200")
          (prop "submenuShowDelay" "0")
          (prop "submenuHideDelay" "0")
          (prop "showIcon" "no")
          (prop "manageDesktops" "yes")
        ])

        (props "applications" [ ])
      ]
    }
  </openbox_config>
''
