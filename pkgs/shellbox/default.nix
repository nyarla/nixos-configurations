{
  writeShellApplication,
  findutils,
  fzy,

  baseDir ? "",
}:
writeShellApplication {
  name = "shellbox";
  runtimeInputs = [
    fzy
    findutils
  ];
  text = ''
    if [[ -z "''${1:-}" ]]; then
      echo "Usage: shellbox <box>";
      exit 1
    fi

    box="''${1}"
    project="$(find '${baseDir}' -maxdepth 1 -type d | fzy)"

    env SHELL=/bin/sh pkexec sh -c "sudo /run/current-system/sw/bin/nixos-container run shellbox -- 'shellbox-''${box}' \"''${project}\""
  '';
}
