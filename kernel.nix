{ ... }:
{
  musnix = {
    enable = false;
    kernel.realtime = true;
  };

  system.stateVersion = "23.11";
}