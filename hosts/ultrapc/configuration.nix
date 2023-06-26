# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:
let
    nix-software-center = inputs.nix-software-center.packages.${pkgs.system}.nix-software-center;
    doom-emacs = inputs.nix-doom-emacs.packages.${pkgs.system}.default;
    nh = inputs.nix-but-gigachad.packages.${pkgs.system}.default;
in {
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
            ./cachix.nix
            inputs.nix-but-gigachad.nixosModules.default
        ];
    nh = {
        enable = true;
        clean.enable = true;
    };
    nix.settings = {
        trusted-users = [ "root" "ultra" ];
        experimental-features = [ "nix-command" "flakes" ];
        substituters = [ 
            "https://hyprland.cachix.org" 
            "https://viperml.cachix.org"
        ];
        trusted-public-keys = [ 
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" 
            "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
        ];
    };

    boot = {
	kernelPackages = pkgs.linuxPackages_latest; # Use the latest kernel
        loader = {
            systemd-boot.enable = true;
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
            };
        };

        plymouth.enable = true;
    };

    networking = {
        hostName = "ultrapc"; # Define your hostname.

        # Enable networking
        networkmanager.enable = true;

        hosts = {
          "192.168.0.221" = [ "pi" "pi-master" ];  
        };

        nameservers = [
            "192.168.1.221"
        ];
    };
    # networking.wireless.enable = true;    # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


    # Set your time zone.
    time.timeZone = "Europe/Bucharest";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.utf8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "ro_RO.utf8";
        LC_IDENTIFICATION = "ro_RO.utf8";
        LC_MEASUREMENT = "ro_RO.utf8";
        LC_MONETARY = "ro_RO.utf8";
        LC_NAME = "ro_RO.utf8";
        LC_NUMERIC = "ro_RO.utf8";
        LC_PAPER = "ro_RO.utf8";
        LC_TELEPHONE = "ro_RO.utf8";
        LC_TIME = "ro_RO.utf8";
    };


    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.ultra = {
        isNormalUser = true;
        description = "Alex S.";
        extraGroups = [
            "networkmanager"
            "wheel"
            "vboxusers"
        ];
        shell = pkgs.fish;
        hashedPassword = "$6$OBjnSQhhJgHsr5LE$jFtUz.2qv0l2viv86exXmfHWC0fDFXKD3rqH41NmqgkdoBrwY2rPkDBCPjdq7PSoeudYcQ0nXxJvh1N7EIUs90";
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment = {
        sessionVariables = {
            QT_QPA_PLATFORMTHEME = "qt5ct";
        };
        systemPackages = with pkgs; [
            wget
            neovim
            neofetch
            podman
            distrobox
            cargo
            nushell
            nerdfonts
            steam-run
            packagekit
            nix-software-center
            fish
            libsForQt5.yakuake
            libsForQt5.discover
            wacomtablet
            git
            starship
            plymouth
            clang-tools
            nil
            pkgconfig
            nh
            ksnip
            virt-manager
        ];
        variables = {
            NIX_AUTO_RUN = "!";
        };
    };
    programs = {
        dconf.enable = true;
        fish.enable = true;
        kdeconnect = {
            enable = true;
        };
        hyprland = {
            enable = true;
        };
        command-not-found.enable = true;
    };
 # programs.nushell.enable = true;
 #    users.defaultUserShell = pkgs.zsh;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #     enable = true;
    #     enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "22.11"; # Did you read the comment?

    system.autoUpgrade.enable = true;
    system.autoUpgrade.allowReboot = false;

    security.sudo.extraConfig =    ''
        Defaults insults
        Defaults pwfeedback
    '';
    
    virtualisation = {
        libvirtd = {
            enable = true;  
        };
        podman = {
            enable = true;
            dockerCompat = true;
            # defaultNetwork.settings.dns_enabled = true;
        };
        waydroid.enable = true;
        lxd.enable = true;
        virtualbox = {
            host = {
                enable = false; # it takes a REALLY long time (and a lot of CPU) to build, and it still doesn't work.
                enableExtensionPack = false; # false because this might build it (idk)
            };

        };
    };


    services = {
        emacs = {
            enable = false; # takes a lot of time to compile
            package = doom-emacs.override {
                doomPrivateDir = ./doom.d;
            };
        };
        flatpak.enable = true;
        packagekit.enable = true;
        xserver = {
            # videoDrivers = [ "nvidia" ];
            wacom.enable = true;

            enable = true;

            # Enable KDE Plasma 5 
            displayManager = {
                /*
                autoLogin = { 
                    enable = false;
                    user = "ultra";
                };
                */

                sddm = {
                    enable = true;
                };
            };
            desktopManager.plasma5.enable = true;

            # Keymap
            layout = "ro";
            xkbVariant = "";
        };
        apcupsd = {
            enable = true;
        };

        # Enable CUPS to print documents.
        printing = {
            enable = true;
        };
        twingate.enable = false;
    };


 # NVIDIA config
# services.xserver.videoDrivers = [ "nvidia" ];
hardware = {
    opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };
    /*
    nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        modesetting.enable = true;
    };
    */
};

}
