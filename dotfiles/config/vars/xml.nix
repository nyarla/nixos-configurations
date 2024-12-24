{ lib }:
rec {
  attrs =
    attributes:
    lib.strings.concatMapAttrsStringSep " " (
      key: value: ''${key}="${lib.strings.escapeXML value}"''
    ) attributes;

  tag = el: "<${el} />";
  tag2 = el: attributes: "<${el} ${attrs attributes}/>";

  el2 = el: contains: "<${el}>${lib.strings.concatStrings contains}</${el}>";
  el3 = el: attributes: contains: ''
    <${el} ${attrs attributes}>
      ${lib.strings.concatStringsSep "\n" contains}
    </${el}>
  '';

  labwc = rec {
    # <command>
    execute = commandline: el2 "command" [ commandline ];
    stop =
      commandline: execute "bash -c 'systemctl --user stop graphic-session.target ; ${commandline}'";

    # <action>
    action =
      label: name:
      el3 "item" { inherit label; } [
        (tag2 "action" { inherit name; })
      ];
    run =
      label: commandline:
      el3 "item" { inherit label; } [
        (el3 "action" { name = "Execute"; } [ (execute commandline) ])
      ];
    script = label: script: run label "bash /etc/nixos/dotfiles/files/scripts/${script}";
    wine = label: app: run label "bash /etc/nixos/dotfiles/files/wine/${app}";

    # <separator />
    sep = tag "separator";

    # <menu>
    list =
      label: id: contains:
      el3 "menu" { inherit label id; } contains;

    include = id: tag2 "menu" { inherit id; };

    # system
    openbox = contains: ''
      <?xml version="1.0" encoding="UTF-8"?>
      <openbox_menu xmlns="http://openbox.org/3.4/menu">
        ${lib.strings.concatStringsSep "\n" contains}
      </openbox_menu>
    '';

    # utilities
    id = id: "applications-${id}";
    sys = id: "system-${id}";
  };
}
