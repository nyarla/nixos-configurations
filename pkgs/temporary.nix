{ nixpkgs, stable, ... }:
final: prev: {
  inherit (stable.legacyPackages.x86_64-linux.pkgs) deadbeef ddcutil ddcui;

  bristol = prev.bristol.overrideAttrs (_: {
    CFLAGS = "-Wno-implicit-int -Wno-implicit-int8 -Wno-implicit-function-declaration";
  });

  whipper = prev.whipper.overrideAttrs (_: {
    postPatch = ''
      sed -i 's|cd-paranoia|${prev.cdparanoia}/bin/cdparanoia|g' whipper/program/cdparanoia.py
    '';
  });

  wivrn-stable = nixpkgs.legacyPackages.x86_64-linux.pkgs.wivrn.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      sed -i 's/Gui QuickControls2 Widgets Network/Gui QuickControls2 Widgets Network GuiPrivate QmlPrivate/' CMakeLists.txt
    '';
  });

  voicevox-engine = prev.voicevox-engine.override { python3Packages = prev.python312Packages; };
  waydroid = prev.waydroid.override { python3Packages = prev.python312Packages; };
  zrythm = prev.zrythm.override { carla = final.carla-with-wine; };
}
