{ buildFHSUserEnv, writeShellScript }:
buildFHSUserEnv rec {
  name = "perl-shell";
  targetPkgs = pkgs:
    with pkgs; [
      gnumake
      openssl.dev
      perl
      perlPackages.Appcpanminus
      perlPackages.PerlTidy
      pkgconfig
      stdenv.cc.cc
      stdenv.cc.libc
      libxcrypt
    ];
  runScript = writeShellScript "perl-env.sh" ''
    exec env IN_PERL_SHELL=1 zsh "''${@}"
  '';
}
