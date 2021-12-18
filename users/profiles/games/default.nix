{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (lib.mkIf (stdenv.hostPlatform.system == "x86_64-linux") runelite)
  ];
}
