{
  description = "Ernest's nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      treefmt = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    rec {
      formatter.x86_64-linux = treefmt.config.build.wrapper;

      checks.x86_64-linux = packages.x86_64-linux // {
        format = treefmt.config.build.check inputs.self;

        lint-statix = pkgs.runCommandLocal "lint-statix" { nativeBuildInputs = [ pkgs.statix ]; } ''
          cd ${inputs.self}
          statix check .
          echo ::error file=flake.nix,line=41,endline=41,title=TestError::Do commands work from external checks?
          touch "$out"
        '';

        lint-deadnix = pkgs.runCommandLocal "lint-deadnix" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          cd ${inputs.self}
          deadnix --fail
          touch "$out"
        '';
      };

      packages.x86_64-linux = import ./pkgs pkgs;

      nixosConfigurations = {
        yoroizuka = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            inputs.musnix.nixosModules.default
            inputs.nixos-cosmic.nixosModules.default
            ./configuration.nix
            ./hosts/yoroizuka.nix
          ];
        };
        kaiki = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            inputs.musnix.nixosModules.default
            inputs.nixos-cosmic.nixosModules.default
            ./configuration.nix
            ./hosts/kaiki.nix
          ];
        };
      };
    };
}
