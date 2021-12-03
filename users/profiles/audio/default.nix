{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (lib.mkIf stdenv.hostPlatform.isLinux ardour)
    musescore
    audacity
  ];
}
