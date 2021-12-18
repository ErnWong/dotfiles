{ pkgs, ... }:
{
  home.packages = [
    (lib.mkIf (stdenv.hostPlatform.system == "x86_64-linux") pkgs.runelite)
  ];
}
