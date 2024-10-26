pkgs: {
  openrct2-develop = pkgs.callPackage ./openrct2 { };
  soundfonts-freepats = pkgs.callPackage ./soundfonts/freepats { };

  # TODO electron 29 is eol
  #waveterm = pkgs.callPackage ./waveterm { };
}
