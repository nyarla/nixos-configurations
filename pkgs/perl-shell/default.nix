{ buildFHSEnv, writeShellScript }:
buildFHSEnv rec {
  name = "perl-shell";
  targetPkgs =
    pkgs: with pkgs; [
      gnumake
      libxcrypt
      openssl.dev
      perl
      perlPackages.Carton
      perlPackages.Appcpanminus
      perlPackages.Appcpm
      perlPackages.PerlTidy
      perlPackages.locallib
      pkg-config
      stdenv.cc.cc
      stdenv.cc.libc
    ];
  runScript = writeShellScript "perl-env.sh" ''
    exec env IN_PERL_SHELL=1 zsh "''${@}"
  '';
}
