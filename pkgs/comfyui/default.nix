{
  fetchFromGitHub,
  fetchPypi,

  autoPatchelfHook,

  python3,
  libx11,
  libxcb,
  libxext,

  stdenv,

  additionalDependencies ? [ ],
}:
let
  python3Packages = python3.pkgs;

  comfy-aimdo = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfy_aimdo";
    version = "0.4.10";
    format = "wheel";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      dist = "cp39";
      python = "cp39";
      abi = "abi3";
      format = "wheel";
      platform = "manylinux2010_x86_64.manylinux2014_x86_64.manylinux_2_12_x86_64.manylinux_2_17_x86_64";
      hash = "sha256-/64FGajDd1HhCX6CdaNFCluL7prrF5tdoMAPy1eizF8=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];
  });

  comfy-kitchen = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfy_kitchen";
    version = "0.2.20";
    format = "wheel";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      dist = "py3";
      python = "py3";
      format = "wheel";
      hash = "sha256-rjpD97bYO84ADxfICehKVSGxyUH3UMYwI7X6HddogT8=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];
  });

  comfy-angle = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfy_angle";
    version = "0.1.0";
    format = "wheel";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      dist = "py3";
      python = "py3";
      format = "wheel";
      platform = "manylinux_2_28_x86_64";
      hash = "sha256-L00X6YQ1PTfSR/r0c6+6vbmGP8OvPgIG+7fYK9wjrGc=";
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
    version = "0.5.8";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-w6fGpXHcTkx7Ur5qAw3kts2ZaNxqneLqKmd2/A5BjwU=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-frontend-package = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_frontend_package";
    version = "1.45.21";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-y4Db4e+Ko9HbFsJ5CTMuxMjHDHQyub4/UIWDGjyGwFs=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    env.COMFYUI_FRONTEND_VERSION = "${finalAttrs.version}";
  });

  comfyui-workflow-templates-core = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_core";
    version = "0.3.272";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-n5Igcqt6CMF8L+Yt195pbd7rHW9qTBIRQvY0umNiRh8=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-json = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_json";
    version = "0.1.6";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-gC1Ix2pHiQMKAHh+ee2gUpUw+MunVI3uWP6T8RWR7k8=";
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
    version = "0.1.3";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-YUR9PVaMp7nHpuC19uLbXEXjaEg8bsRizAj5FxSuxnM=";
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
    version = "0.11.9";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-S4A8YtghCpjuOfwIDkJuKWXIvSdCWborhyMmepNE5OE=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    dependencies = [
      comfyui-workflow-templates-core
      comfyui-workflow-templates-json
      comfyui-workflow-templates-media-api
      comfyui-workflow-templates-media-assets-01
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
  version = "v0.28.0";
  format = "other";
  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI";
    tag = finalAttrs.version;
    hash = "sha256-p75qcm6eRMWaVD89xac2biu58hN2FcxW1QgNujlGxAA=";
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
      pillow
      psutil
      pydantic
      pydantic-settings
      pyopengl
      pyyaml
      requests
      safetensors
      scipy
      sentencepiece
      simpleeval
      sqlalchemy
      tokenizers
      torch
      torchaudio
      torchsde
      torchvision
      tqdm
      transformers
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
