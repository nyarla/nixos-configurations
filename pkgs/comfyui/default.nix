{
  fetchFromGitHub,
  fetchPypi,

  autoPatchelfHook,

  python3,

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
    version = "0.2.10";
    format = "wheel";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      dist = "py3";
      python = "py3";
      format = "wheel";
      hash = "sha256-wkKv0Y0SDij8lJxCP6KMuyLLTXDWJ9jMfN9rrVTdJyw=";
    };
  });

  comfyui-embedded-docs = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_embedded_docs";
    version = "0.5.5";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-i408A+rDdlH32IRMZzL+/iHfU7sYyoNFPUs4pwReBzM=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-frontend-package = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_frontend_package";
    version = "1.45.19";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-OnDV//yclToE5WEMAZXkj6/YM3RQa/qtoL1FoxEgCP4=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-core = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_core";
    version = "0.3.260";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-/PQoQLVQ+s4FSBrKX61VvpFMqPW8KCUcPJCIsdU6F3I=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-media-api = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_media_api";
    version = "0.3.81";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-xFtptkePtTZMhtuYvI9s6tNxXA+YK3YJUo0lzGzuY9Y=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-media-video = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_media_video";
    version = "0.3.97";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-/0FxBuw4XWW+eYA7w8xwMZcMFgjU0Q9H8Gx1NDiZ31w=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-media-image = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_media_image";
    version = "0.3.155";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-CYRZWU+43kb0PODu1i7485EPPRO96ljz3f+4B4NMs9U=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates-media-other = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates_media_other";
    version = "0.3.223";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-pwA/M+t2JVYns8evBySHxzadlgjy+WWMf+NfHaSHLTI=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];
  });

  comfyui-workflow-templates = python3Packages.buildPythonPackage (finalAttrs: {
    pname = "comfyui_workflow_templates";
    version = "0.10.3";
    src = fetchPypi {
      inherit (finalAttrs) pname version;
      hash = "sha256-tKIYtZUT6v258GgEplgU9dsfomAXFggHx1EegL5UcOI=";
    };
    pyproject = true;
    build-system = with python3Packages; [ setuptools ];

    dependencies = [
      comfyui-workflow-templates-core
      comfyui-workflow-templates-media-api
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
  version = "v0.26.0";
  format = "other";
  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI";
    tag = finalAttrs.version;
    hash = "sha256-P+b18jzuWT3J0fCniFFEASx9ufivulCza/nHuIZRge8=";
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
