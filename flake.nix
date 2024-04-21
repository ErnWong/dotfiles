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

    nixpkgs-older-nushell.url = "https://api.flakehub.com/f/pinned/NixOS/nixpkgs/0.1.555097%2Brev-91050ea1e57e50388fa87a3302ba12d188ef723a/018c3450-2363-7c34-883b-4ba70b1eb7ae/source.tar.gz"; # Provides Nushell v0.87.1
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
      older-nushell = (import inputs.nixpkgs-older-nushell { system = "x86_64-linux"; }).nushell;
      nuhelper = {
        mkDerivation = inputs.nuenv.lib.mkNushellDerivation older-nushell pkgs.system;
        mkScript = { name, script } : pkgs.writeTextFile {
          inherit name;
          executable = true;
          text = ''
            #!${pkgs.lib.getExe pkgs.nushell} --stdin

            ${script}
          '';
        };
      };
      checkers = import ./checks (inputs // { inherit pkgs nuhelper; });
    in
    rec {
      formatter.x86_64-linux = treefmt.config.build.wrapper;

      checks.x86_64-linux = packages.x86_64-linux // checkers.checks // {
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
