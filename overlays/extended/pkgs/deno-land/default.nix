{ stdenv, fetchurl, patchelf, gzip }:
stdenv.mkDerivation rec {
  name    = "deno-${version}";
  version = "v0.28.1";
  src     = fetchurl {
    url     = "https://github.com/denoland/deno/releases/download/${version}/deno_linux_x64.gz";
    sha256  = "0ky9rib3sgqwpdw4hwgly2i2m18b99jfmk0rfhwk426pnyi28vpi";
  };

  propargatedBuildInputs = [ patchelf gzip ];

  unpackPhase = ''
    cp ${src} deno.gz
    gunzip deno.gz
    chmod +w deno
  '';

  buildPhase = ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      deno
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp deno $out/bin/deno
    chmod 755 $out/bin/deno
  '';
}
