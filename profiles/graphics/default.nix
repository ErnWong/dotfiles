{ pkgs, ... }:
{
  dragon-freezer = {
    enable = true;
    immutable = true;
    settings.mouse.cursorTheme = "breeze_cursors";
    settings.mouse.cursorSize = 48;
  };

  hardware = {
    video.hidpi.enable = false;
    opengl.enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    libinput.enable = true;
  };
}
