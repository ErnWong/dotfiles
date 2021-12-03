{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wezterm
    fira-code
    fira-code-symbols
  ];

  fonts.fontconfig.enable = true; # TODO: Probably make this overridable / default
}
