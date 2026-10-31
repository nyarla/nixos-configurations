{
  callPackage,
  lib,

  alsa-lib,
  libva,
}:
let
  craft =
    pname: datetime: inputs:
    callPackage (import ./artcraft.nix) (inputs // { inherit pname datetime; });
  datetime = "2026-10-18";
in
{
  photocraft = craft "photocraft" datetime {
    features = [
      "photocraft/heif"
      "photocraft-cli/heif"
    ];

    cargoHashes = {
      "craft-docpath-0.1.0" = "sha256-/8I9DcqtsznoYPo4ECc/rPQIal6P9gyPksrvVHDW6Mg=";
      "craft-jpeg-0.1.0" = "sha256-UuN/HpAyX3HdmkV46d0GY+n0yzlCmImetwlG0anzhRM=";
      "craft-print-0.1.0" = "sha256-uXP0zITi8i1JDUyc451FmZ0Pl1ZK4D0rlTJQmGFVm0I=";
      "craft-ui-0.1.0" = "sha256-VhLeT7VLdZAIz6gR9PdFI34IJxHsGF8NE0uzFCN2vIU=";
      "craft-winprint-gdi-0.1.0" = "sha256-n1pcNaBGrnvSsE5MedeSRczJOMhfmF/LGFiiDTrG1GM=";
      "ecolor-0.37.0" = "sha256-xzgBk6K1X/MZ8WUlIdy+r/0cf1FDkhJJuwQHZX+WY9U=";
      "winprint-0.2.1" = "sha256-wnz/VbqQ3j/x1PEq6Elxu/oSjVqdONfqQmZ31NsTIIc=";
      "winit-0.30.13" = "sha256-+67bk7cqhM5VHqROL3PeghmhKJvlPIxhU73ay45vaxw=";
    };

    patches = [
      ./photocraft-v0.17.0.patch
    ];
  };

  vectorcraft = craft "vectorcraft" datetime {
    cargoHashes = {
      "craft-docpath-0.1.0" = "sha256-/8I9DcqtsznoYPo4ECc/rPQIal6P9gyPksrvVHDW6Mg=";
      "craft-keymap-0.1.0" = "sha256-HCnlcjCWLoFXdYw5cOupO5pekDAb9+UmV5yH44YoaGg=";
      "craft-pdf-0.1.0" = "sha256-6r1iIlwK6HlUkascw0e4R9L2H5WMgKO2y6PEa51Flws=";
      "craft-print-0.1.0" = "sha256-J/EJJeDDWXc+QQtpUqnAKKA4piOdPRbH3uG1ms2BRgY=";
      "craft-ui-0.1.0" = "sha256-VhLeT7VLdZAIz6gR9PdFI34IJxHsGF8NE0uzFCN2vIU=";
      "craft-window-0.1.0" = "sha256-JoZPAF3aNabwNtk6a6g3Llzaguk6y5st5K02Hq0TorE=";
      "craft-winprint-gdi-0.1.0" = "sha256-n1pcNaBGrnvSsE5MedeSRczJOMhfmF/LGFiiDTrG1GM=";
      "ecolor-0.37.0" = "sha256-xzgBk6K1X/MZ8WUlIdy+r/0cf1FDkhJJuwQHZX+WY9U=";
      "winprint-0.2.1" = "sha256-wnz/VbqQ3j/x1PEq6Elxu/oSjVqdONfqQmZ31NsTIIc=";
      "winit-0.30.13" = "sha256-+67bk7cqhM5VHqROL3PeghmhKJvlPIxhU73ay45vaxw=";
    };

    patches = [
      ./vectorcraft-v0.18.0.patch
    ];
  };

  filmcraft = craft "filmcraft" datetime {
    features = [
      "filmcraft/neural-voices"
      "filmcraft/whisper"
      "filmcraft-cli/whisper"
    ];

    extraBuildInputs = [
      alsa-lib
      libva
    ];

    cargoHashes = {
      "craft-docpath-0.1.0" = "sha256-/8I9DcqtsznoYPo4ECc/rPQIal6P9gyPksrvVHDW6Mg=";
      "craft-media-0.1.0" = "sha256-JfBkl7/RX3Fn1nCn0bpKsvtFhb8CVfOtkHp/ISuXc00=";
      "craft-ui-0.1.0" = "sha256-VhLeT7VLdZAIz6gR9PdFI34IJxHsGF8NE0uzFCN2vIU=";
      "craft-update-0.1.0" = "sha256-pVw3q17lCuOc0eX0S3pWjEtLLo1SaIno98YRlgTk6vg=";
      "ecolor-0.37.0" = "sha256-xzgBk6K1X/MZ8WUlIdy+r/0cf1FDkhJJuwQHZX+WY9U=";
      "winit-0.30.13" = "sha256-+67bk7cqhM5VHqROL3PeghmhKJvlPIxhU73ay45vaxw=";
    };

    patches = [
      ./flimcraft-v0.15.0.patch
    ];
  };

  lightcraft = craft "lightcraft" datetime {
    features = [
      "lightcraft/denoise"
      "lightcraft/heif"
      "lightcraft/rawnind-model"
      "lightcraft-cli/denoise"
      "lightcraft-cli/rawnind-model"
    ];

    cargoHashes = {
      "craft-docpath-0.1.0" = "sha256-ufVzS079k4yeeiPExB0oW/nQW5Fi8Xog0tQoDRL+26k=";
      "craft-ui-0.1.0" = "sha256-VhLeT7VLdZAIz6gR9PdFI34IJxHsGF8NE0uzFCN2vIU=";
    };
  };

  # pdfcraft = craft "pdfcraft" datetime {
  #   cargoHashes = {
  #     "craft-docpath-0.1.0" = "sha256-ufVzS079k4yeeiPExB0oW/nQW5Fi8Xog0tQoDRL+26k=";
  #     "craft-print-0.1.0" = "sha256-c3z9zbzTPZI+ByJdhnvypa+h5ahvgX3f7D1lqKAWzOI=";
  #     "craft-ui-0.1.0" = "sha256-VhLeT7VLdZAIz6gR9PdFI34IJxHsGF8NE0uzFCN2vIU=";
  #     "craft-quit-0.1.0" = "sha256-1jW/Zlj2VZK7yDoC0dq9taDH5L3i16XphbFx3eI1+cQ=";
  #     "winprint-0.2.1" = "sha256-wnz/VbqQ3j/x1PEq6Elxu/oSjVqdONfqQmZ31NsTIIc=";
  #   };
  # };

  effectcraft = craft "effectcraft" datetime {
    cargoHashes = {
      "craft-docpath-0.1.0" = "sha256-ufVzS079k4yeeiPExB0oW/nQW5Fi8Xog0tQoDRL+26k=";
      "craft-pdf-0.1.0" = "sha256-6r1iIlwK6HlUkascw0e4R9L2H5WMgKO2y6PEa51Flws=";
      "craft-ui-0.1.0" = "sha256-VhLeT7VLdZAIz6gR9PdFI34IJxHsGF8NE0uzFCN2vIU=";
      "filmcraft-aac-0.1.1" = "sha256-WXiX4rF7zSwfu3yu9aNH2/xWYhAYFVX1rdrnccuTD7g=";
    };

    extraBuildInputs = [
      alsa-lib
      libva
    ];
  };

  designcraft = craft "designcraft" datetime {
    cargoHashes = {
      "craft-atomic-0.1.0" = "sha256-pFFP92/ogEdDJT7VEq6NTM7ggO8d73kA7pfJ7vhBPIo=";
      "craft-docpath-0.1.0" = "sha256-ufVzS079k4yeeiPExB0oW/nQW5Fi8Xog0tQoDRL+26k=";
      "craft-pdf-0.1.0" = "sha256-/6fOawiZ5TP/beP8B/8KQrmYTnBY0QSZfcgapcbJOYE=";
      "craft-print-0.1.0" = "sha256-J/EJJeDDWXc+QQtpUqnAKKA4piOdPRbH3uG1ms2BRgY=";
      "craft-ui-0.1.0" = "sha256-VhLeT7VLdZAIz6gR9PdFI34IJxHsGF8NE0uzFCN2vIU=";
      "hayro-0.7.1" = "sha256-xGbwY2SCjT1QTwVczSm3kSOxpweYfjd/2zgGk7EhqCE=";
      "indd-0.1.0" = "sha256-9buHpnMVC8NPbe0JwF1guqoxeVv6PdO3OVcjSQk9fmk=";
      "winit-0.30.13" = "sha256-q1gDwAj8xU/2OC4CtCG72ZvrkZ436V3zsqh5hovLTcs=";
    };
  };

  figcraft = craft "figcraft" datetime {
    cargoHashes = {
      "craft-docpath-0.1.0" = "sha256-ufVzS079k4yeeiPExB0oW/nQW5Fi8Xog0tQoDRL+26k=";
    };
  };

  wordcraft = craft "wordcraft" datetime {
    cargoHashes = {
      "craft-pdf-0.1.0" = "sha256-/6fOawiZ5TP/beP8B/8KQrmYTnBY0QSZfcgapcbJOYE=";
      "craft-print-0.1.0" = "sha256-u2AR5YZZSRzhWaevgR2S/jofD99J3YWKJA+CktUJbRY=";
    };
  };

  soundcraft = craft "soundcraft" datetime {
    cargoHashes = {
      "craft-docpath-0.1.0" = "sha256-ufVzS079k4yeeiPExB0oW/nQW5Fi8Xog0tQoDRL+26k=";
      "craft-ui-0.1.0" = "sha256-VhLeT7VLdZAIz6gR9PdFI34IJxHsGF8NE0uzFCN2vIU=";
    };

    extraBuildInputs = [
      alsa-lib
    ];
  };

  deckcraft = craft "deckcraft" datetime {
    cargoHashes = {
      "craft-pdf-0.1.0" = "sha256-/6fOawiZ5TP/beP8B/8KQrmYTnBY0QSZfcgapcbJOYE=";
    };

    extraBuildInputs = [
      alsa-lib
    ];
  };

  cadcraft = craft "cadcraft" datetime {
    cargoHashes = {
      "craft-docpath-0.1.0" = "sha256-ufVzS079k4yeeiPExB0oW/nQW5Fi8Xog0tQoDRL+26k=";
      "craft-ui-0.1.0" = "sha256-VhLeT7VLdZAIz6gR9PdFI34IJxHsGF8NE0uzFCN2vIU=";
    };
  };

  gridcraft = craft "gridcraft" datetime {
    cargoHashes = {
      "craft-print-0.1.0" = "sha256-u2AR5YZZSRzhWaevgR2S/jofD99J3YWKJA+CktUJbRY=";
    };
  };
}
