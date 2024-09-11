pkgs: {
  openrct2-develop = pkgs.callPackage ./openrct2 { };

  # TODO electron 29 is eol
  #waveterm = pkgs.callPackage ./waveterm { };
}
