{
  stdenv,
  fetchFromGitHub,
  libei,
  libffi,
  sdbus-cpp,
  systemd,
  wayland,
  wayland-protocols,
  wayland-scanner,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "xdg-desktop-portal-hypr-remote";
  version = "git";
  src = fetchFromGitHub {
    owner = "gac3k";
    repo = pname;
    rev = "f463018129c5effd3b82b477d7f84fe0d0820a6b";
    hash = "sha256-hbRlPcrPWOKWZvLlnsw37/s4P+bLRq59n+R9qtVbIXc=";
  };

  buildInputs = [
    libei
    libffi
    sdbus-cpp
    systemd.dev
    wayland
    wayland-protocols
    wayland-scanner
    wayland.dev
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  postInstall = ''
    cp -r $out/bin $out/libexec

    install -Dm644 org.freedesktop.impl.portal.desktop.hypr-remote.service \
      $out/share/dbus-1/services/org.freedesktop.impl.portal.desktop.hypr-remote.service

    install -Dm644 contrib/systemd/xdg-desktop-portal-hypr-remote.service \
      $out/share/systemd/user/xdg-desktop-portal-hypr-remote.service
  '';
}
