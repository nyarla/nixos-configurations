_: {
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "nofile";
      value = "655360";
    }
    {
      domain = "*";
      item = "memlock";
      type = "-";
      value = "655360";
    }
  ];
}
