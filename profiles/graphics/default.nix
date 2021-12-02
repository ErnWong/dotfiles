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

  fonts.fonts = with pkgs; {
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
  };
}
