{
  description = "Ernest's nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, nixos-cosmic }@inputs: {
    nixosConfigurations = {
      yoroizuka = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          nixos-cosmic.nixosModules.default
          ./configuration.nix
          ./hosts/yoroizuka.nix
        ];
      };
    };
  };
}