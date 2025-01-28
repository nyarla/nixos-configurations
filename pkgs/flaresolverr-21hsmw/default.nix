# This package is based on https://github.com/nix-community/nur-combined/blob/master/repos/xddxdd/pkgs/uncategorized/flaresolverr-21hsmw/default.nix
#
# MIT License
#
# Copyright (c) 2018 Francesco Gazzetta
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
{
  lib,
  fetchFromGitHub,
  stdenv,
  python3,
  makeWrapper,
  chromium,
  xorg,
  undetected-chromedriver,
  ...
}:
let
  selenium' = python3.pkgs.callPackage ./selenium { };
  python3-undetected-chromedriver' = python3.pkgs.undetected-chromedriver.override {
    selenium = selenium';
  };
  undetected-chromedriver' = undetected-chromedriver.overrideAttrs (_old: {
    nativeBuildInputs = [ (python3.withPackages (_ps: [ python3-undetected-chromedriver' ])) ];
  });
  python = python3.withPackages (
    p: with p; [
      bottle
      waitress
      selenium'
      func-timeout
      psutil
      prometheus-client
      requests
      certifi
      packaging
      websockets
      deprecated
      mss
      xvfbwrapper
    ]
  );

  path = lib.makeBinPath [
    chromium
    undetected-chromedriver'
    xorg.xorgserver
  ];
in
stdenv.mkDerivation rec {
  pname = "flaresolverr-21hsmw";
  version = "23273a62a0d1f5cf3afb89a3ca016053ad82f88b";
  src = fetchFromGitHub {
    owner = "21hsmw";
    repo = "FlareSolverr";
    rev = "23273a62a0d1f5cf3afb89a3ca016053ad82f88b";
    hash = "sha256-yb43jzBIxHAhsReZUuGWNduyM2Qm/P+FaSTQf1O06ew=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace src/utils.py \
      --replace 'PATCHED_DRIVER_PATH = None' 'PATCHED_DRIVER_PATH = "${undetected-chromedriver'}/bin/undetected-chromedriver"'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/opt
    cp -r * $out/opt/

    makeWrapper ${python}/bin/python $out/bin/flaresolverr \
      --add-flags "$out/opt/src/flaresolverr.py" \
      --set PATH "${path}"

    runHook postInstall
  '';

  meta.mainProgram = "flaresolverr";
}
