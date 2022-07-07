self: super:
let require = path: super.callPackage (import path);
in {
  quodlibet =
    super.quodlibet.overrideAttrs (_: rec { doInstallCheck = false; });
}
