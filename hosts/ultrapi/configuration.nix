
  { config, pkgs, lib, inputs, ... }:

  let
    user = "ultra";
    hashedPassword = "$6$OBjnSQhhJgHsr5LE$jFtUz.2qv0l2viv86exXmfHWC0fDFXKD3rqH41NmqgkdoBrwY2rPkDBCPjdq7PSoeudYcQ0nXxJvh1N7EIUs90";
    hostname = "ultrapi";

    helix = inputs.helix.packages.${pkgs.system}.default;


    nixosHardware = pkgs.fetchFromGitHub {
          owner = "NixOS";
          repo = "nixos-hardware";
          rev = "51559e691f1493a26f94f1df1aaf516bb507e78b";
          sha256 = "0spswivyk006h5xr0a0yhr7wr9fh0kg7cfyxqmk521svf3x1pnr8";
    };
  in {

    # imports = ["${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz" }/raspberry-pi/4"];

    imports = [
      "${nixosHardware}/raspberry-pi/4"
    ];

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = [ "noatime" ];
      };
    };

    networking = {
      hostName = hostname;
    };

    environment.systemPackages = with pkgs; [
      vim
      helix
      docker
    ];

    services.openssh.enable = true;

    users = {
      mutableUsers = false;
      users."${user}" = {
        isNormalUser = true;
        hashedPassword = "${hashedPassword}";
        extraGroups = [ "wheel" ];
      };
    };

    # Enable GPU acceleration
    hardware.raspberry-pi."4".fkms-3d.enable = true;

    services.xserver = {
      enable = false;
    };

    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = true;
        rootless = {
          enable = true;
        };
      };
    };


    security = { 
      sudo = {
        extraConfig = ''
          Defaults insults,pwfeedback
        '';
      };
     };

    nixpkgs = { 
      config = { 
        allowUnfree = true;
      };
    };
  }
