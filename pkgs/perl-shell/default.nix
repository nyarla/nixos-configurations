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
      stdenv.cc.cc
    ];
  runScript = writeShellScript "perl-env.sh" ''
    exec env IN_PERL_SHELL=1 zsh --login
  '';
}
