{ config, pkgs, ... }:

{
  security.apparmor = {
    enable = true;
    killUnconfinedConfinables = true;
  };

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.frequency = 12;
  };

  services.cloudflare-warp.enable = true;

  environment.systemPackages = with pkgs; [
    cloudflare-warp
    clamav
    apparmor-utils
    firejail
  ];

  networking.firewall = {
    enable = true;
    allowPing = false;
  };
}
