{ config, pkgs, ... }:

{
  nixpkgs.config.packageOverrides = super: {
    openldap = super.openldap.overrideAttrs (oldAttrs: {
      doCheck = false;
    });
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    lutris heroic mangohud protonup-qt
  ];
}
