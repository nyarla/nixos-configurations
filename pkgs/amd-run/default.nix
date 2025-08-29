{ writeShellScriptBin, gpuId }:
writeShellScriptBin "amd-run" ''
  env \
    DRI_PRIME=${gpuId}! \
    MESA_VK_DEVICE_SELECT=${gpuId} \
    AMD_VULKAN_ICD=RADV \
    VK_ICD_FILENAMES=/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json \
    "''${@:-}"
''
