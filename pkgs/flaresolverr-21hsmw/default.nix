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
  stdenv,
  python3,
  makeWrapper,
  chromium,
  xorg,
  undetected-chromedriver,
  fetchFromGitHub,
}:
let
  python = python3.withPackages (
    p: with p; [
      bottle
      waitress
      selenium
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
    undetected-chromedriver
    xorg.xorgserver
  ];
in
stdenv.mkDerivation rec {
  pname = "flaresolverr-21hsmw";
  version = "e7880c8a5de7914a6c7039b66a8b0ff143adee29";
  src = fetchFromGitHub {
    owner = "21hsmw";
    repo = "FlareSolverr";
    rev = version;
    hash = "sha256-VVr9tDOE15gqYmi9AHwUkbY7LmBGrQeeenXfp21PEKY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace src/utils.py \
      --replace 'PATCHED_DRIVER_PATH = None' 'PATCHED_DRIVER_PATH = "${undetected-chromedriver}/bin/undetected-chromedriver"'
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
