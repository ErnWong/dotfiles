{ pkgs, ... }:
{
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
