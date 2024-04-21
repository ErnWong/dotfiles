{ self, pkgs, nuhelper, ... }:
let
  checkers = {
    statix = import ./statix.nix pkgs;
    deadnix = import ./deadnix.nix pkgs;
  };
  machine-readable-output = builtins.mapAttrs (name: checker: nuhelper.mkDerivation {
    name = "machine-readable-output-${name}";
    inherit (checker) packages;
    src = self;
    build = ''
      ${nuhelper.mkScript {
        name = "machine-readable-output-${name}-script";
        script = checker.machine-readable;
      }} | save $env.out
    '';
  }) checkers;
in
{
  checks = builtins.mapAttrs (name: checker: nuhelper.mkDerivation {
    inherit (checker) packages;
    name = "check-${name}";
    src = self;
    build = ''
      if (open --raw ${machine-readable-output."${name}"} | is-empty) {
        echo 'Checks passed'
      } else {
        ${nuhelper.mkScript {
          name = "check-${name}-script";
          script = checker.human-readable;
        }}
      }
      touch $env.out
    '';
  }) checkers;
  apps = builtins.mapAttrs (name: checker: {
    type = "app";
    program = "" + nuhelper.mkScript {
      name = "annotate-${name}";
      script = ''
        let annotations = open --raw ${machine-readable-output."${name}"} | ${nuhelper.mkScript {
          name = "annotate-${name}-script";
          script = checker.to-github-annotations;
        }}
        if ($annotations | is-empty) {
          echo 'Checks passed'
        } else {
          echo $annotations
          exit 1
        }
      '';
    };
  }) checkers;
}