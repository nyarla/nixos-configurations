{
  gcc12Stdenv,
  flutter,
  cmake,
  ninja,
  pkg-config,
  makeWrapper,
  fetchFromGitHub,
  fetchurl,
  pcre2,
  libdeflate,
}:

let
  realmLinuxVersion = "0.9.0+rc";
  realmLinuxVersionUrlSafe = "0.9.0%2Brc";
  realmLinuxBinary = fetchurl {
    url = "https://static.realm.io/downloads/dart/${realmLinuxVersionUrlSafe}/linux.tar.gz";
    sha256 = "sha256-2Xaac9wlvZ4wMogJ40VHuY9nv7WT2zrveKppQz/UbFk=";
  };
in
flutter.mkFlutterApp rec {
  pname = "NovelAIManager";
  version = "2023-01-21";
  src = fetchFromGitHub {
    owner = "riku1227";
    repo = "NovelAIManager";
    rev = "16dc3dff86bb5a3fb2a25eb24fe6186860e75655";
    sha256 = "sha256-69VnSEMbKkvJau0Veb4QyOvZMnQt+nOBBIqIJriykrg=";
  };

  buildInputs = [
    pcre2
    libdeflate
  ];
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    makeWrapper
  ];

  patches = [ ./linux-support.patch ];

  vendorSha256 = "sha256-XpPWpZovQyOgq1pNXKo+AOObs9/5xkaMD1+c6qdPoc8=";

  flutterExtraFetchCommands = ''
    mkdir -p $HOME/.pub-cache/hosted/pub.dartlang.org/realm-0.9.0+rc/linux/binary/linux
    tar zxvf ${realmLinuxBinary} -C $HOME/.pub-cache/hosted/pub.dartlang.org/realm-${realmLinuxVersion}/linux/binary/linux/ 
    echo -n "${realmLinuxVersion}" >$HOME/.pub-cache/hosted/pub.dartlang.org/realm-${realmLinuxVersion}/linux/binary/linux/realm_version.txt

    touch .packages
  '';

  postFixup = ''
    wrapProgram $out/bin/novelai_manager \
      --set LD_LIBRARY_PATH "${gcc12Stdenv.cc.cc.lib}/lib:$out/app/lib"
  '';
}
