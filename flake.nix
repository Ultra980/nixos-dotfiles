{
    description = "My NixOS system configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nix-software-center = {
            url = "github:vlinkz/nix-software-center";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        helix = {
            url = "github:helix-editor/helix/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    	nixos-hardware = {
            url = "github:NixOS/nixos-hardware";
        };
        nixpkgs-master.url = "github:NixOS/nixpkgs/master";
        hypr-contrib = {
            url = "github:hyprwm/contrib";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland = {
            url = "github:hyprwm/Hyprland";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        eww = {
            url = "github:elkowar/eww";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-but-gigachad = {
            url = "github:viperML/nh";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        everblush = {
            url = "github:Ultra980/everblush-gtk-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs: {
        nixosConfigurations = {
            titan = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                # specialArgs = { inherit inputs; };
                modules = [
                    ( import ./hosts/titan/configuration.nix inputs )
                    {
                        environment.etc."nix/inputs/nixpkgs".source = nixpkgs.outPath;    
                        nix.nixPath = [ 
                            "nixpkgs=/etc/nix/inputs/nixpkgs"
                            "nixos-config=/home/ultra/.nixdotfiles"
                        ];
                    }

                    # Hyprland
                    # inputs.hyprland.nixosModules.default
                    # { programs.hyprland.enable = true; }
                ];
            };
            hermes = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    ./hosts/hermes/configuration.nix
                    {
                        environment.etc."nix/inputs/nixpkgs".source = nixpkgs.outPath;
                        nix.nixPath = [
                            "nixpkgs=/etc/nix/inputs/nixpkgs"
                            "nixos-config=/home/ultra/.nixdotfiles"  
                        ];
                    }
                ];
            };
            ultrapi = nixpkgs.lib.nixosSystem {
                system = "aarch64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    ./hosts/ultrapi/configuration.nix
                    {
                        environment.etc."nix/inputs/nixpkgs".source = nixpkgs.outPath;
                        nix.nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
                    }
                ];
            };
            iso = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-plasma5-new-kernel.nix"
                ];
            };
        };
        defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
        defaultPackage.aarch64-linux = home-manager.defaultPackage.aarch64-linux;
        homeConfigurations = {
            ultra = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                modules = [
                    ( import ./users/ultra/home.nix inputs )
                    (args: { # https://ayats.org/blog/channels-to-flakes
                         xdg.configFile."nix/inputs/nixpkgs".source = nixpkgs.outPath;
                         home.sessionVariables.NIX_PATH = "nixpkgs=${args.config.xdg.configHome}/nix/inputs/nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
                    })
                    # Hyprland
                    # inputs.hyprland.homeManagerModules.default
                    # { wayland.windowManager.hyprland.enable = true; }
                ];
            }; 
        };
    };
}
