{ pkgs, ... }:
{
  #environment.extraInit = ''
  #export XDG_CONFIG_DIRS="/home/nixos/repos/test-kde-config:$XDG_CONFIG_DIRS"
  #''; # Hardcoded directory for testing purposes. TODO
  dragon-freezer = {
    enable = true;
    immutable = true;
    settings.mouse.cursorTheme = "KDE_Classic";
  };

  hardware = {
    video.hidpi.enable = false;
    opengl.enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
  };
}
