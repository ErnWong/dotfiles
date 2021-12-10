{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      wezterm
    ];
    enableDebugInfo = true;
  };
}
