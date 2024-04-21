{ pkgs, nuhelper, ... }:
let
unused=if true == true then 1 else 0;
unused2=if true == true then 1 else 0;
  checkers = {
    #treefmt = import ./treefmt.nix pkgs;
    statix = import ./statix.nix pkgs;
    deadnix = import ./deadnix.nix pkgs;
  };
  machine-readable-output = builtins.mapAttrs (name: checker: nuhelper.mkDerivation {
    name = "machine-readable-output-${name}";
    inherit (checker) packages;
    src = ./..;
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
    src = ./..;
    build = ''
      if open --raw ${machine-readable-output} | is-empty {
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
        open --raw ${machine-readable-output."${name}"} | ${nuhelper.mkScript {
          name = "annotate-${name}-script";
          script = checker.to-github-annotations;
        }}
      '';
    };
  }) checkers;
}