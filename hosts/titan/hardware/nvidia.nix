inputs: { config, pkgs, lib, ... }: {
  # NVIDIA config
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };
    
    nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
        powerManagement.enable = true;
        open = true;
        nvidiaSettings = true;
    };
  };
}