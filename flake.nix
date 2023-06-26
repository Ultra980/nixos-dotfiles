{
    description = "My NixOS system configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nix-software-center.url = "github:vlinkz/nix-software-center";
        nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        helix.url = "github:helix-editor/helix/master";  
	nixos-hardware.url = "github:NixOS/nixos-hardware";

        nixpkgs-master.url = "github:NixOS/nixpkgs/master";
        hypr-contrib.url = "github:hyprwm/contrib";
        hyprland.url = "github:hyprwm/Hyprland";
        eww.url = "github:elkowar/eww";
        nix-but-gigachad.url = "github:viperML/nh";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs: {
        nixosConfigurations = {
            ultrapc = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = { inherit inputs; };
                modules = [
                    ./hosts/ultrapc/configuration.nix
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
                extraSpecialArgs = { inherit inputs; };
                modules = [
                    ./users/ultra/home.nix
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
