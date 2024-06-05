_: {
  hardware.cpu.amd.updateMicrocode = true;

  # fix for kernel stuck on reboot or shutdown process with Ryzen Processor
  boot.kernelParams = [ "processor.max_cstate=1" ];
}
