_: {
  # update microcode
  hardware.cpu.amd.updateMicrocode = true;

  # workaround for machines getting stuck during shutdown
  boot.kernelParams = [ "processor.max_cstate=1" ];
}
