{
  fetchFromGitHub,
  fetchPypi,

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

  comfy-aimdo = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfy_aimdo";
    version = "0.5.5";
    format = "wheel";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      dist = "cp39";
      python = "cp39";
      abi = "abi3";
      format = "wheel";
      platform = "manylinux2014_x86_64.manylinux_2_17_x86_64";
      hash = "sha256-ek3HaDEnOi+Df2fPScnlB+d4sZr/F+bvijSm6WlP2Go=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];
    pythonImportsCheck = [
      "comfy_aimdo"
      "comfy_aimdo.storage"
    ];
  });

  comfy-kitchen = python3Packages.buildPythonPackage {
    pname = "comfy_kitchen";
    version = "0.2.37";
    src = fetchFromGitHub {
      owner = "Comfy-Org";
      repo = "comfy-kitchen";
      tag = "v0.2.37";
      hash = "sha256-wvEmnW302yaGOjZ0UcwFyS8zOUi1XRi3so4r1wU7w/s=";
    };

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

  comfy-angle = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfy_angle";
    version = "0.1.1";
    format = "wheel";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      dist = "py3";
      python = "py3";
      format = "wheel";
      platform = "manylinux_2_28_x86_64";
      hash = "sha256-PS/KuThuu7VlPWZpb6i8rTKcHRhS6kth8obqmUhahAo=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      libx11
      libxext
      libxcb
      stdenv.cc.cc
    ];
  });

  comfyui-embedded-docs = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_embedded_docs";
    version = "0.5.13";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-odDCe13S0fyOC/PHe1jgZkrvCtRggE5Z4WVKqo4bhJw=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-frontend-package = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_frontend_package";
    version = "1.53.10";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-yx3MvEfYtQ0yLmeBP+q5eYZBZ7LrLmKHn71YxU8tKrI=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    env.COMFYUI_FRONTEND_VERSION = "${finalAttrs.version}";
  });

  comfyui-workflow-templates-core = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_core";
    version = "0.3.367";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-dXfZQfDtA2bSAx+ujz2wy/pjwLs9chf65rNucA/dJgA=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-json = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_json";
    version = "0.1.102";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-6fciXxJ2fjuo0kkEy/wA7H0m0XStTYh8fDgDu/U2sgg=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-media-api = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_media_api";
    version = "0.3.84";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-a9XEluNo5eQN2H3+JfBm4k1X82AoiLo9+AATqI0GAlk=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-media-assets-01 = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_media_assets_01";
    version = "0.1.48";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-sSxDn1KoVFsKjjIej2LXqogaS9jcnIicO73pexDnEg8=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-media-assets-02 = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_media_assets_02";
    version = "0.1.9";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-nrH44RF16lFzn67WgPAb1JYcWheOEWnkOFnMr5j1aPA=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-media-video = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_media_video";
    version = "0.3.101";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-dlLtmfubsAs52JBZGdyBUJIB4zXd4jqXNroTiRmQhHY=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-media-image = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_media_image";
    version = "0.3.160";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-iNz3STAsahL1uAPftGcktMiswx0RF87P9RZy2b2F6xg=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-media-other = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_media_other";
    version = "0.3.229";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-bi2wdS8sfOlPaoudRBpfnceLv6dldF8PnqyuzLzmk4U=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates";
    version = "0.11.76";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-iPfppPQ4uJVhphtwRMP9fkLY1HSCoW3EMSZNVX3gHSg=";
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
  });

  spandrel = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "spandrel";
    version = "0.4.2";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-/vpOqWbGpbdyHc8k8+IGKlqWo5XIvty1cPtVlx/cvMs=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    dependencies = with python3Packages; [
      einops
      numpy
      safetensors
      torch
      torchvision
      typing-extensions
    ];
  });
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ComfyUI";
  version = "v0.39.0";
  format = "other";
  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI";
    tag = finalAttrs.version;
    hash = "sha256-1QZQmMfLzko9HPBGFMEZuHjroxTIjxR2taZVHosIW3E=";
  };

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
      sqlalchemy
      tokenizers
      torch
      torchaudio
      torchsde
      torchvision
      tqdm
      transformers
      triton
      yarl
    ])
    ++ [
      comfy-aimdo
      comfy-angle
      comfy-kitchen
      comfyui-embedded-docs
      comfyui-frontend-package
      comfyui-workflow-templates

      spandrel
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
})
