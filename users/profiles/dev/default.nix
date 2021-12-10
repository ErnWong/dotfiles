{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      (lib.mkIf stdenv.hostPlatform.isLinux wezterm)
      gdb
    ];
    enableDebugInfo = true;
  };
}
