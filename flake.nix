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
        helix.url = "github:helix-editor/helix";    
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
                        nix.nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
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
                ];
            }; 
        };
    };
}
