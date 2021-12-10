{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
  ];
  programs = {
    chromium.enable = true;
  };
}
