{ pkgs, ... }: {
  users.users.nyarla.extraGroups = [
    # "kvm"
    # "libvirtd"
    # "vboxusers"
  ];
}
