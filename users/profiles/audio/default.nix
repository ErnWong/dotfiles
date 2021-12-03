{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (lib.mkIf stdenv.hostPlatform.isLinux ardour)
    (lib.mkIf stdenv.hostPlatform.isLinux audacity)
    musescore
  ];
}
