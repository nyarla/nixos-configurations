{ config, pkgs, lib, ... }: {
  i18n.inputMethod = {
    enabled = "uim";
    uim.toolbar = "gtk3-systray";
  };

  services.dbus.packages = [ config.i18n.inputMethod.package ];

  environment.systemPackages = with pkgs; [ skk-dicts skktools ];

  nixpkgs.overlays = [
    (self: super: {
      uim = super.uim.overrideAttrs (old: rec {
        buildInputs = (lib.remove super.qt4 old.buildInputs)
          ++ [ super.qt5Full ];

        prePatch = ''
          mkdir -p $out/lib/qt-${super.qt5.qtbase.version}/plugins/platforminputcontexts

          sed -i 's/qmake-qt5 qmake5/qmake/' m4/ax_path_qmake5.m4
          sed -i 's!''${QTDIR}!${super.qt5.qtbase.bin}!' m4/ax_path_qmake5.m4
          sed -i 's|test ! -d "$QTDIR/plugins"|false|' configure.ac
          sed -i 's|QT_PLUGINSDIR=$QTDIR/plugins|QT_PLUGINSDIR=$out/plugins|' configure.ac
          sed -i 's|@DESTDIR@..\[QT_INSTALL_PLUGINS\]/platforminputcontexts|$(out)/lib/qt-${super.qt5.qtbase.version}/plugins/platforminputcontexts|' qt5/immodule/quimplatforminputcontextplugin.pro.in

        '' + old.prePatch;

        configureFlags = ((lib.remove "--with-qt4")
          ((lib.remove "--with-qt4-immodule") old.configureFlags)) ++ [
            "--with-qt5"
            "--with-qt5-immodule"
            "--without-qt4"
            "--without-qt4-module"
          ];

        postConfigure = ''
          sed -i 's|$(INSTALL_ROOT)/build/source/qt5/immodule/||g' qt5/immodule/Makefile.qmake
        '';

        dontWrapQtApps = true;
      });
    })
  ];
}
