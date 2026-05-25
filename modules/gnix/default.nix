{ config, pkgs, lib, ... }:

{
  imports = [ ../hardware ];

  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

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
    lutris
    heroic
    bottles
    wineWowPackages.stagingFull
    winetricks
    cabextract
    dxvk
    vkd3d-proton
    vulkan-tools
    vulkan-validation-layers
    vulkan-extension-layer
    mangohud
    gamescope
    protonup-qt
    nvtopPackages.full
    unityhub
    jdk21
  ];
}
