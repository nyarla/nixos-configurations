{ lib, ... }: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      # fonts
      font-family = [
        "HackGen Console"
        "Hack Nerd Font"
        "Noto Color Emoji"
        "Noto Sans Symbols"
        "Noto Sans Symbols2"
      ];
      font-size = 12;
      font-codepoint-map = [
        "U+E000-U+F8FF=Hack Nerd Font"
        "U+F0000-U+FFFFD=Hack Nerd Font"
        "U+A9,U+AE,U+200D,U+203C,U+2049,U+20E3,U+2122,U+2139,U+2194-U+2199,U+21A9-U+21AA,U+231A-U+231B,U+2328,U+23CF,U+23E9-U+23F3,U+23F8-U+23FA,U+24C2,U+25AA-U+25AB,U+25B6,U+25C0,U+25FB-U+25FE,U+2600-U+2604,U+260E,U+2611,U+2614-U+2615,U+2618,U+261D,U+2620,U+2622-U+2623,U+2626,U+262A,U+262E-U+262F,U+2638-U+263A,U+2640,U+2642,U+2648-U+2653,U+265F-U+2660,U+2663,U+2665-U+2666,U+2668,U+267B,U+267E-U+267F,U+2692-U+2697,U+2699,U+269B-U+269C,U+26A0-U+26A1,U+26AA-U+26AB,U+26B0-U+26B1,U+26BD-U+26BE,U+26C4-U+26C5,U+26C8,U+26CE-U+26CF,U+26D1,U+26D3-U+26D4,U+26E9-U+26EA,U+26F0-U+26F5,U+26F7-U+26FA,U+26FD,U+2702,U+2705,U+2708-U+270D,U+270F,U+2712,U+2714,U+2716,U+271D,U+2721,U+2728,U+2733-U+2734,U+2744,U+2747,U+274C,U+274E,U+2753-U+2755,U+2757,U+2763-U+2764,U+2795-U+2797,U+27A1,U+27B0,U+27BF,U+2934-U+2935,U+2B05-U+2B07,U+2B1B-U+2B1C,U+2B50,U+2B55,U+3030,U+303D,U+3297,U+3299,U+FE0F,U+1F004,U+1F0CF,U+1F170-U+1F171,U+1F17E-U+1F17F,U+1F18E,U+1F191-U+1F19A,U+1F1E6-U+1F1FF,U+1F201-U+1F202,U+1F21A,U+1F22F,U+1F232-U+1F23A,U+1F250-U+1F251,U+1F300-U+1F321,U+1F324-U+1F393,U+1F396-U+1F397,U+1F399-U+1F39B,U+1F39E-U+1F3F0,U+1F3F3-U+1F3F5,U+1F3F7-U+1F4FD,U+1F4FF-U+1F53D,U+1F549-U+1F54E,U+1F550-U+1F567,U+1F56F-U+1F570,U+1F573-U+1F57A,U+1F587,U+1F58A-U+1F58D,U+1F590,U+1F595-U+1F596,U+1F5A4-U+1F5A5,U+1F5A8,U+1F5B1-U+1F5B2,U+1F5BC,U+1F5C2-U+1F5C4,U+1F5D1-U+1F5D3,U+1F5DC-U+1F5DE,U+1F5E1,U+1F5E3,U+1F5E8,U+1F5EF,U+1F5F3,U+1F5FA-U+1F64F,U+1F680-U+1F6C5,U+1F6CB-U+1F6D2,U+1F6D5,U+1F6E0-U+1F6E5,U+1F6E9,U+1F6EB-U+1F6EC,U+1F6F0,U+1F6F3-U+1F6FA,U+1F7E0-U+1F7EB,U+1F90D-U+1F93A,U+1F93C-U+1F945,U+1F947-U+1F971,U+1F973-U+1F976,U+1F97A-U+1F9A2,U+1F9A5-U+1F9AA,U+1F9AE-U+1F9CA,U+1F9CD-U+1F9FF,U+1FA70-U+1FA73,U+1FA78-U+1FA7A,U+1FA80-U+1FA82,U+1FA90-U+1FA95,U+E0062-U+E0063,U+E0065,U+E0067,U+E006C,U+E006E,U+E0073-U+E0074,U+E0077,U+E007F=Noto Color Emoji"
      ];

      theme = "light:kalaclista,dark:kalaclista";
      cursor-style-blink = true;

      keybind = [
        "ctrl+p=paste_from_clipboard"
      ];

      shell-integration-features = true;
    };

    themes.kalaclista = with (import ../../../lib/theme.nix); {
      background = gray05;
      foreground = gray100;
      cursor-color = green90;
      selection-background = blue90;
      selection-foreground = gray05;
      palette = lib.lists.imap0 (idx: val: "${toString idx}=${val}") [
        gray00
        red65
        green85
        yellow85
        blue85
        magenta95
        cyan85
        gray95
        gray65
        red75
        green90
        yellow90
        blue90
        magenta90
        cyan95
        gray100
      ];
    };
  };
}
