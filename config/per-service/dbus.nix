{ config, pkgs, lib, ... }:
let
  target = config.environment.systemPackages
    ++ [ config.i18n.inputMethod.package ];

  addDBus = pkg: ns: ''
    if test -d ${pkg}/${ns} ; then
      cd ${pkg}/${ns}

      for file in $(ls); do
        if test -f $file ; then
          ln -sf ${pkg}/${ns}/$file $out/${ns}/$file
        fi
      done
    fi
  '';

  dbusBundlePackage = pkgs.runCommand "dbus-bundle" { } ''
    mkdir -p $out/etc/dbus-1/session.d
    mkdir -p $out/etc/dbus-1/system.d
    mkdir -p $out/share/dbus-1/services
    mkdir -p $out/share/dbus-1/session.d
    mkdir -p $out/share/dbus-1/system-services
    mkdir -p $out/share/dbus-1/system.d

    ${lib.concatMapStrings (p: addDBus p "etc/dbus-1/session.d") target} 
    ${lib.concatMapStrings (p: addDBus p "etc/dbus-1/system.d") target} 
    ${lib.concatMapStrings (p: addDBus p "share/dbus-1/services") target} 
    ${lib.concatMapStrings (p: addDBus p "share/dbus-1/session.d") target} 
    ${
      lib.concatMapStrings (p: addDBus p "share/dbus-1/system-services") target
    } 
    ${lib.concatMapStrings (p: addDBus p "share/dbus-1/system.d") target} 
  '';
in { services.dbus.packages = lib.singleton dbusBundlePackage; }
