{ inputs, ...}: {
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth = {
      enable = true;
      theme = "bowlbird-logo";
      themePackages =  [
        inputs.plymouth-theme-bowlbird-logo.packages.x86_64-linux.default
      ];
    };

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "rd.udev.log_priority=3"
   ];

    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 100;
      };
    };
  };
}
