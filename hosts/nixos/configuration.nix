{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/security
  ];

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot";

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
    useOSProber = true;
    configurationLimit = 10;
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Istanbul";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  system.nixos.label = "NIXOS";

  users.users.m = {
    isNormalUser = true;
    description = "m";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
  };

  specialisation = {
    gnix.configuration = {
      system.nixos.label = lib.mkForce "GNIX";
      imports = [ ../../modules/gnix ];
    };
    codex.configuration = {
      system.nixos.label = lib.mkForce "CODEX";
      imports = [ ../../modules/dev ];
    };
  };

  system.stateVersion = "25.11";
}
