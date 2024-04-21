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

    nuenv.url = "github:DeterminateSystems/nuenv";
  };

  outputs =
    inputs:
    let
      pkgs = import inputs.nixpkgs {
        overlays = [ inputs.nuenv.overlays.default ];
        system = "x86_64-linux";
      };
      treefmt = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      checkers = import ./checks pkgs;
    in
    rec {
      formatter.x86_64-linux = treefmt.config.build.wrapper;

      checks.x86_64-linux = packages.x86_64-linux // checkers.checks {
        format = treefmt.config.build.check inputs.self;

        #lint-statix = pkgs.runCommandLocal (if true == true then "lint-statix" else "") { nativeBuildInputs = [ pkgs.statix ]; } ''
        #  cd ${inputs.self}
        #  touch "$out"
        #  statix check . || statix check . --format json > "$out"
        #  echo ::error file=flake.nix,line=41,endline=41,title=TestError::Do commands work from external checks?
        #'';

        #lint-deadnix = pkgs.runCommandLocal "lint-deadnix" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
        #  cd ${inputs.self}
        #  touch "$out"
        #  deadnix --fail || deadnix --fail --output-format json > "$out"
        #'';
      };

      apps.x86_64-linux = checkers.apps // {
        #annotate-statix = {
        #  type = "app";
        #  program = pkgs.nuenv.writeScriptBin {
        #    name = "annotate-statix";
        #    text = ''
        #      open --raw "${checks.x86_64-linux.lint-statix}" | from json 
        #    '';
        #  };
        #};
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
