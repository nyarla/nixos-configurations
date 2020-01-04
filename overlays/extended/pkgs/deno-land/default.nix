{ stdenv, fetchurl, patchelf, gzip }:
stdenv.mkDerivation rec {
  name    = "deno-${version}";
  version = "v0.23.0";
  src     = fetchurl {
    url     = "https://github.com/denoland/deno/releases/download/${version}/deno_linux_x64.gz";
    sha256  = "14mk9k29mhfv6yszb2k01nnp4rai1phvsrs6sxr71y7vd8rz9j4n";
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
