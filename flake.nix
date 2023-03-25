{
  description = "My NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-software-center.url = "github:vlinkz/nix-software-center";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.ultrapc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./ultrapc/configuration.nix
      ];
    };
  };
}
