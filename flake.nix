{
  description = "Ernest's nix configuration";

  inputs = {
    nixpkgs-stable-ernest.url = "github:nixos/nixpkgs/nixos-unstable"; # TODO I'm seeing two nixpkgs-stable? in the lock file? nixpkgs-stable is pinned to 24.11 while nixpkgs-stable2 is pinned to master? What is doing the 24.11? Ah, it's coming from cosmic. TODO - I was using the wrong branch the whole time. master is more bleeding edge than unstable, and release-26.05 is too old it seems. lets use unstable.
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable-ernest";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs-stable-ernest";
    };
    #nixos-cosmic = {
    #  url = "github:lilyinstarlight/nixos-cosmic";
    #  inputs.nixpkgs.follows = "nixpkgs-stable-ernest";
    #};

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable-ernest";
    };

    icantbelievegit = {
      url = "github:ErnWong/i-cant-believe-gits-not-a-file";
      inputs.nixpkgs.follows = "nixpkgs-stable-ernest";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-stable-ernest";
    };

    neominimap = {
      url = "github:Isrothy/neominimap.nvim";
      flake = false;
    };

    # Newer nushell breaks nuenv, and has some weird stdout/stderr+exit handling that I
    # haven't figured out yet, so we're using an older version of nushell.
    nixpkgs-older-nushell.url = "https://api.flakehub.com/f/pinned/NixOS/nixpkgs/0.1.555097%2Brev-91050ea1e57e50388fa87a3302ba12d188ef723a/018c3450-2363-7c34-883b-4ba70b1eb7ae/source.tar.gz"; # Provides Nushell v0.87.1
    nuenv.url = "github:DeterminateSystems/nuenv";

    # TODO https://github.com/logseq/logseq/issues/10851 https://github.com/NixOS/nixpkgs/pull/347293 https://github.com/NixOS/nixpkgs/issues/341683
    nixpkgs-logseq-fix.url = "github:aktaboot/nixpkgs/logseq-source";
    nixpkgs-logseq.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs-factorio1.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs-olive-editor.url = "github:nixos/nixpkgs/d09aec1b2769b6d64e590c0fa921cef2415529db";
  };

  outputs =
    inputs:
    let
      pkgs = import inputs.nixpkgs-stable-ernest {
        overlays = [
          inputs.nuenv.overlays.default
        ];
        system = "x86_64-linux";
      };
      treefmt = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      older-nushell = (import inputs.nixpkgs-older-nushell { system = "x86_64-linux"; }).nushell;
      nuhelper = {
        mkDerivation = inputs.nuenv.lib.mkNushellDerivation older-nushell pkgs.system;
        mkScript =
          { name, script }:
          pkgs.writeTextFile {
            inherit name;
            executable = true;
            text = ''
              #!${pkgs.lib.getExe older-nushell} --stdin

              ${script}
            '';
          };
      };
      checkers = import ./checks (inputs // { inherit pkgs nuhelper; });
    in
    rec {
      formatter.x86_64-linux = treefmt.config.build.wrapper;

      checks.x86_64-linux =
        packages.x86_64-linux // checkers.checks // { format = treefmt.config.build.check inputs.self; };

      apps.x86_64-linux = checkers.apps;

      packages.x86_64-linux = import ./pkgs pkgs;

      nixosConfigurations = {
        #installerIsoWithUsbModeSwitch = inputs.nixpkgs-stable-ernest.lib.nixosSystem {
        #  modules = [
        #    ({ pkgs, modulesPath, ... }: {
        #      imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix") ];
        #      hardware.usb-modeswitch.enable = true; # Some USB WiFi adapters present themselves as installation cdroms at first, so enable auto modeswitch to fix WiFi.
        #      nixpkgs.hostPlatform = "x86_64-linux";
        #      
        #    })
        #  ];
        #};
        yoroizuka = inputs.nixpkgs-stable-ernest.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            #inputs.musnix.nixosModules.default
            #inputs.nixos-cosmic.nixosModules.default
            ./configuration.nix
            ./hosts/yoroizuka.nix
          ];
        };
        kaiki = inputs.nixpkgs-stable-ernest.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            #inputs.musnix.nixosModules.default
            #inputs.nixos-cosmic.nixosModules.default
            ./configuration.nix
            ./hosts/kaiki.nix
          ];
        };
        #wenli = inputs.nixpkgs-stable-ernest.lib.nixosSystem {
        #  specialArgs = {
        #    inherit inputs;
        #  };
        #  modules = [
        #    inputs.authentik-nix.nixosModules.default
        #    ./hosts/wenli.nix
        #  ];
        #};
      };
    };
}
