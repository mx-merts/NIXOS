{ config, pkgs, ... }:

{
  home.username      = "m";
  home.homeDirectory = "/home/m";

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
