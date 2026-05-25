{ config, pkgs, ... }:

{
  i18n.defaultLocale = "tr_TR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT    = "tr_TR.UTF-8";
    LC_MONETARY       = "tr_TR.UTF-8";
    LC_NAME           = "tr_TR.UTF-8";
    LC_NUMERIC        = "tr_TR.UTF-8";
    LC_PAPER          = "tr_TR.UTF-8";
    LC_TELEPHONE      = "tr_TR.UTF-8";
    LC_TIME           = "tr_TR.UTF-8";
  };

  services.xserver.xkb = { layout = "tr"; variant = ""; };
  console.keyMap = "trq";

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  programs.fish.enable = true;
  users.users.m.shell = pkgs.fish;
# ---------------------------------------------------------------- #
  # FLATPAK + FLATHUB                                                 #
  # ---------------------------------------------------------------- #
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  
  environment.systemPackages = with pkgs; [
    wezterm fish starship fzf zoxide bat eza ripgrep fd jq fastfetch
    micro vim
    git wget curl btop pciutils usbutils unzip zip p7zip wl-clipboard
    kdePackages.kdenlive shotcut
    gimp pinta
    xournalpp kdePackages.okular
    onlyoffice-desktopeditors
    vlc discord spotify
    obs-studio flameshot
    vscode
    firefox
  ];
}
