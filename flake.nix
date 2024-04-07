{
  description = "Ernest's nix configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url ="github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, musnix, nixos-cosmic, ... }@inputs: {
    nixosConfigurations = {
      yoroizuka = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          musnix.nixosModules.default
          nixos-cosmic.nixosModules.default
          ./configuration.nix
          ./hosts/yoroizuka.nix
        ];
      };
      kaiki = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          musnix.nixosModules.default
          nixos-cosmic.nixosModules.default
          ./configuration.nix
          ./hosts/kaiki.nix
        ];
      };
    };
  };
}
