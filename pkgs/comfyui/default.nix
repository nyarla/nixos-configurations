{
  sources,

  fetchFromGitHub,
  fetchPypi,
  fetchurl,

  autoPatchelfHook,
  symlinkJoin,

  python3,
  libx11,
  libxcb,
  libxext,
  rocmPackages,
  cmake,
  ninja,

  stdenv,

  additionalDependencies ? [ ],
}:
let
  python3Packages = python3.pkgs;
  rocm-sdk = symlinkJoin {
    name = "rocm-merged";
    paths = with rocmPackages; [
      clr
      hipcc
      llvm.clang
      rocm-core
      rocm-comgr
      rocm-device-libs
      rocm-runtime
    ];
  };

  comfy-aimdo = python3Packages.buildPythonPackage {
    pname = "comfy_aimdo";
    version = "0.5.6";
    format = "wheel";
    src = fetchurl {
      inherit (sources.comfy-aimdo) url hash;
    };
    nativeBuildInputs = [ autoPatchelfHook ];
    pythonImportsCheck = [
      "comfy_aimdo"
      "comfy_aimdo.storage"
    ];
  };

  comfy-kitchen = python3Packages.buildPythonPackage {
    pname = "comfy_kitchen";
    inherit (sources.comfy-kitchen) version;
    src = sources.comfy-kitchen;

    pyproject = true;

    build-system =
      (with python3Packages; [
        nanobind
        setuptools
        wheel
      ])
      ++ [
        python3Packages.cmake
        python3Packages.ninja
      ];

    nativeBuildInputs = [
      cmake
      ninja
      rocm-sdk
    ];

    env = {
      COMFY_KITCHEN_BUILD_HIP = "1";
      COMFY_HIP_ARCHS = "gfx1201";
    };

    dontUseCmakeConfigure = true;
    dontUseNinjaBuild = true;
    dontUseNinjaCheck = true;
    dontUseNinjaInstall = true;
  };

  comfy-angle = python3Packages.buildPythonPackage {
    pname = "comfy_angle";
    version = "0.1.1";
    format = "wheel";
    src = fetchurl {
      inherit (sources.comfy-angle) url hash;
    };

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      libx11
      libxext
      libxcb
      stdenv.cc.cc
    ];
  };

  comfyui-embedded-docs = python3Packages.buildPythonPackage {
    pname = "comfyui_embedded_docs";
    inherit (sources.comfyui-embedded-docs) version;
    src = fetchurl {
      inherit (sources.comfyui-embedded-docs) url hash;
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  };

  comfyui-frontend-package = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_frontend_package";
    inherit (sources.comfyui-frontend-package) version;
    src = fetchurl {
      inherit (sources.comfyui-frontend-package) url hash;
    };

    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    env.COMFYUI_FRONTEND_VERSION = "${finalAttrs.version}";
  });

  comfyui-workflow-templates-core = python3Packages.buildPythonPackage {
    pname = "comfyui_workflow_templates_core";
    inherit (sources.comfyui-workflow-templates-core) version;
    src = fetchurl {
      inherit (sources.comfyui-workflow-templates-core) url hash;
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  };

  comfyui-workflow-templates-json = python3Packages.buildPythonPackage {
    pname = "comfyui_workflow_templates_json";
    inherit (sources.comfyui-workflow-templates-json) version;
    src = fetchurl {
      inherit (sources.comfyui-workflow-templates-json) url hash;
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  };

  comfyui-workflow-templates-media-api = python3Packages.buildPythonPackage {
    pname = "comfyui_workflow_templates_media_api";
    inherit (sources.comfyui-workflow-templates-media-api) version;
    src = fetchurl {
      inherit (sources.comfyui-workflow-templates-media-api) url hash;
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  };

  comfyui-workflow-templates-media-assets-01 = python3Packages.buildPythonPackage {
    pname = "comfyui_workflow_templates_media_assets_01";
    inherit (sources.comfyui-workflow-templates-media-assets-01) version;
    src = fetchurl {
      inherit (sources.comfyui-workflow-templates-media-assets-01) url hash;
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  };

  comfyui-workflow-templates-media-assets-02 = python3Packages.buildPythonPackage {
    pname = "comfyui_workflow_templates_media_assets_02";
    inherit (sources.comfyui-workflow-templates-media-assets-02) version;
    src = fetchurl {
      inherit (sources.comfyui-workflow-templates-media-assets-02) url hash;
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  };

  comfyui-workflow-templates-media-video = python3Packages.buildPythonPackage {
    pname = "comfyui_workflow_templates_media_video";
    inherit (sources.comfyui-workflow-templates-media-video) version;
    src = fetchurl {
      inherit (sources.comfyui-workflow-templates-media-video) url hash;
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  };

  comfyui-workflow-templates-media-image = python3Packages.buildPythonPackage {
    pname = "comfyui_workflow_templates_media_image";
    inherit (sources.comfyui-workflow-templates-media-image) version;
    src = fetchurl {
      inherit (sources.comfyui-workflow-templates-media-image) url hash;
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  };

  comfyui-workflow-templates-media-other = python3Packages.buildPythonPackage {
    pname = "comfyui_workflow_templates_media_other";
    inherit (sources.comfyui-workflow-templates-media-other) version;
    src = fetchurl {
      inherit (sources.comfyui-workflow-templates-media-other) url hash;
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  };

  comfyui-workflow-templates = python3Packages.buildPythonPackage {
    pname = "comfyui_workflow_templates";
    inherit (sources.comfyui-workflow-templates) version;
    src = fetchurl {
      inherit (sources.comfyui-workflow-templates) url hash;
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    dependencies = [
      comfyui-workflow-templates-core
      comfyui-workflow-templates-json
      comfyui-workflow-templates-media-api
      comfyui-workflow-templates-media-assets-01
      comfyui-workflow-templates-media-assets-02
      comfyui-workflow-templates-media-image
      comfyui-workflow-templates-media-other
      comfyui-workflow-templates-media-video
    ];
  };
in
python3Packages.buildPythonApplication {
  pname = "ComfyUI";
  version = "v0.39.0";
  format = "other";
  src = sources.ComfyUI;

  dependencies =
    (with python3Packages; [
      aiohttp
      alembic
      av
      blake3
      einops
      filelock
      glfw
      kornia
      numpy
      pillow
      psutil
      pydantic
      pydantic-settings
      pyopengl
      pyopengl-accelerate
      pyyaml
      requests
      safetensors
      scipy
      sentencepiece
      simpleeval
      spandrel
      spandrel
      sqlalchemy
      tokenizers
      torch
      torchaudio
      torchsde
      torchvision
      tqdm
      transformers
      triton
      typing-extensions
      yarl
    ])
    ++ [
      comfy-aimdo
      comfy-angle
      comfy-kitchen
      comfyui-embedded-docs
      comfyui-frontend-package
      comfyui-workflow-templates
    ]
    ++ additionalDependencies;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r . $out/bin

    mkdir -p $out/bin/user
    mkdir -p $out/bin/temp

    sed -i '1i #!/usr/bin/env python3' $out/bin/main.py
    chmod +x $out/bin/main.py

    runHook postInstall
  '';
}
