final: prev: {
  # keep sources this first
  sources = prev.callPackage (import ./_sources/generated.nix) { };
  # then, call packages with `final.callPackage`
  extraterm = final.callPackage (import ./applications/terminal-emulators/extraterm) { };
}
