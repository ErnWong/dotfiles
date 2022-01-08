final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  yarn2nix-fixed = final.callPackage (import ./development/tools/yarn2nix-moretea/yarn2nix-fixed) { };
  extraterm = final.callPackage (import ./applications/terminal-emulators/extraterm) { };
}
