pkgs:
let
  checkers = {
    #treefmt = import ./treefmt.nix pkgs;
    statix = import ./statix.nix pkgs;
    deadnix = import ./deadnix.nix pkgs;
  };
  machine-readable-output = builtins.mapAttrs (name: checker: pkgs.nuenv.mkDerivation {
    inherit name;
    inherit (checker) packages;
    src = ./..;
    system = "x86_64-linux";
    build = ''
      ${pkgs.nuenv.writeScriptBin {
        inherit name;
        script = checker.machine-readable;
      }} > $out
    '';
  }) checkers;
in
{
  checks = builtins.mapAttrs (name: checker: pkgs.nuenv.mkDerivation {
    inherit (checker) packages;
    name = "check-${name}";
    src = ./..;
    system = "x86_64-linux";
    build = ''
      if open --raw ${machine-readable-output} | is-empty {
        'Checks passed'
      } else {
        ${pkgs.nuenv.writeScriptBin {
          inherit name;
          script = checker.human-readable;
        }}
      }
      touch $out
    '';
  }) checkers;
  apps = builtins.mapAttrs (name: checker: {
    type = "app";
    program = "" + pkgs.nuenv.writeScriptBin {
      name = "annotate-${name}";
      script = ''
        open --raw ${machine-readable-output."${name}"} | ${pkgs.nuenv.writeScriptBin {
          name = "annotate-${name}";
          script = checker.to-github-annotations;
        }}
      '';
    };
  }) checkers;
}