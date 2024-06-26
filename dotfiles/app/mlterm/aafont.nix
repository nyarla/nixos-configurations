{ system, ... }:
let
  mapEmoji = font: {
    "U+A9" = font;
    "U+AE" = font;
    "U+200D" = font;
    "U+203C" = font;
    "U+2049" = font;
    "U+20E3" = font;
    "U+2122" = font;
    "U+2139" = font;
    "U+2194-2199" = font;
    "U+21A9-21AA" = font;
    "U+231A-231B" = font;
    "U+2328" = font;
    "U+23CF" = font;
    "U+23E9-23F3" = font;
    "U+23F8-23FA" = font;
    "U+24C2" = font;
    "U+25AA-25AB" = font;
    "U+25B6" = font;
    "U+25C0" = font;
    "U+25FB-25FE" = font;
    "U+2600-2604" = font;
    "U+260E" = font;
    "U+2611" = font;
    "U+2614-2615" = font;
    "U+2618" = font;
    "U+261D" = font;
    "U+2620" = font;
    "U+2622-2623" = font;
    "U+2626" = font;
    "U+262A" = font;
    "U+262E-262F" = font;
    "U+2638-263A" = font;
    "U+2640" = font;
    "U+2642" = font;
    "U+2648-2653" = font;
    "U+265F-2660" = font;
    "U+2663" = font;
    "U+2665-2666" = font;
    "U+2668" = font;
    "U+267B" = font;
    "U+267E-267F" = font;
    "U+2692-2697" = font;
    "U+2699" = font;
    "U+269B-269C" = font;
    "U+26A0-26A1" = font;
    "U+26AA-26AB" = font;
    "U+26B0-26B1" = font;
    "U+26BD-26BE" = font;
    "U+26C4-26C5" = font;
    "U+26C8" = font;
    "U+26CE-26CF" = font;
    "U+26D1" = font;
    "U+26D3-26D4" = font;
    "U+26E9-26EA" = font;
    "U+26F0-26F5" = font;
    "U+26F7-26FA" = font;
    "U+26FD" = font;
    "U+2702" = font;
    "U+2705" = font;
    "U+2708-270D" = font;
    "U+270F" = font;
    "U+2712" = font;
    "U+2714" = font;
    "U+2716" = font;
    "U+271D" = font;
    "U+2721" = font;
    "U+2728" = font;
    "U+2733-2734" = font;
    "U+2744" = font;
    "U+2747" = font;
    "U+274C" = font;
    "U+274E" = font;
    "U+2753-2755" = font;
    "U+2757" = font;
    "U+2763-2764" = font;
    "U+2795-2797" = font;
    "U+27A1" = font;
    "U+27B0" = font;
    "U+27BF" = font;
    "U+2934-2935" = font;
    "U+2B05-2B07" = font;
    "U+2B1B-2B1C" = font;
    "U+2B50" = font;
    "U+2B55" = font;
    "U+3030" = font;
    "U+303D" = font;
    "U+3297" = font;
    "U+3299" = font;
    "U+FE0F" = font;
    "U+1F004" = font;
    "U+1F0CF" = font;
    "U+1F170-1F171" = font;
    "U+1F17E-1F17F" = font;
    "U+1F18E" = font;
    "U+1F191-1F19A" = font;
    "U+1F1E6-1F1FF" = font;
    "U+1F201-1F202" = font;
    "U+1F21A" = font;
    "U+1F22F" = font;
    "U+1F232-1F23A" = font;
    "U+1F250-1F251" = font;
    "U+1F300-1F321" = font;
    "U+1F324-1F393" = font;
    "U+1F396-1F397" = font;
    "U+1F399-1F39B" = font;
    "U+1F39E-1F3F0" = font;
    "U+1F3F3-1F3F5" = font;
    "U+1F3F7-1F4FD" = font;
    "U+1F4FF-1F53D" = font;
    "U+1F549-1F54E" = font;
    "U+1F550-1F567" = font;
    "U+1F56F-1F570" = font;
    "U+1F573-1F57A" = font;
    "U+1F587" = font;
    "U+1F58A-1F58D" = font;
    "U+1F590" = font;
    "U+1F595-1F596" = font;
    "U+1F5A4-1F5A5" = font;
    "U+1F5A8" = font;
    "U+1F5B1-1F5B2" = font;
    "U+1F5BC" = font;
    "U+1F5C2-1F5C4" = font;
    "U+1F5D1-1F5D3" = font;
    "U+1F5DC-1F5DE" = font;
    "U+1F5E1" = font;
    "U+1F5E3" = font;
    "U+1F5E8" = font;
    "U+1F5EF" = font;
    "U+1F5F3" = font;
    "U+1F5FA-1F64F" = font;
    "U+1F680-1F6C5" = font;
    "U+1F6CB-1F6D2" = font;
    "U+1F6D5" = font;
    "U+1F6E0-1F6E5" = font;
    "U+1F6E9" = font;
    "U+1F6EB-1F6EC" = font;
    "U+1F6F0" = font;
    "U+1F6F3-1F6FA" = font;
    "U+1F7E0-1F7EB" = font;
    "U+1F90D-1F93A" = font;
    "U+1F93C-1F945" = font;
    "U+1F947-1F971" = font;
    "U+1F973-1F976" = font;
    "U+1F97A-1F9A2" = font;
    "U+1F9A5-1F9AA" = font;
    "U+1F9AE-1F9CA" = font;
    "U+1F9CD-1F9FF" = font;
    "U+1FA70-1FA73" = font;
    "U+1FA78-1FA7A" = font;
    "U+1FA80-1FA82" = font;
    "U+1FA90-1FA95" = font;
    "U+E0062-E0063" = font;
    "U+E0065" = font;
    "U+E0067" = font;
    "U+E006C" = font;
    "U+E006E" = font;
    "U+E0073-E0074" = font;
    "U+E0077" = font;
    "U+E007F" = font;
  };
in
{
  x86_64-linux = {
    DEFAULT = "Monospace";
    "U+E000-F8FF" = "Hack Nerd Font";
    "U+F0000-FFFFD" = "Hack Nerd Font";
  } // mapEmoji "Noto Color Emoji";
}
."${system}"
