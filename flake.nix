{
  description = "My NixOS system configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.ultrapc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./ultrapc/configuration.nix
      ];
    };
  };
}
