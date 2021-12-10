{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      wezterm
      gdb
    ];
    enableDebugInfo = true;
  };
}
