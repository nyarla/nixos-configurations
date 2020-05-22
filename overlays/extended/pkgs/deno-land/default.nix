{ stdenv, fetchzip, patchelf, gzip }:
stdenv.mkDerivation rec {
  name = "deno-${version}";
  version = "v1.0.0-rc1";
  src = fetchzip {
    url = "https://github.com/denoland/deno/releases/download/v1.0.0-rc1/deno-x86_64-unknown-linux-gnu.zip";
    sha256 = "04fhrshxxi7n8qcy3dhllpjkkr2zb6vjikpyy0wpzsvdlc1kyyd6";
  };

  propargatedBuildInputs = [ patchelf gzip ];

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
