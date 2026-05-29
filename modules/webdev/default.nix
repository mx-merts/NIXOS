{ config, pkgs, ... }:

{
  # ================================================================ #
  #  WEBDEV MODÜLÜ — MariaDB · Apache · PHP · Adminer · .NET         #
  # ================================================================ #

  # ---------------------------------------------------------------- #
  # 1. MARİADB (MySQL uyumlu)                                        #
  # ---------------------------------------------------------------- #
  services.mysql = {
    enable  = true;
    package = pkgs.mariadb;
  };

  # ---------------------------------------------------------------- #
  # 2. APACHE + PHP + ADMİNER                                        #
  # ---------------------------------------------------------------- #
  services.httpd = {
    enable     = true;
    enablePHP  = true;
    phpPackage = pkgs.php83;
    adminAddr  = "admin@localhost";

    virtualHosts."localhost" = {
      documentRoot = "/srv/http";
      extraConfig  = ''
        <Directory "/srv/http">
          AllowOverride All
          Require all granted
        </Directory>

        Alias /adminer ${pkgs.adminer}/adminer.php
        <Files "${pkgs.adminer}/adminer.php">
          Require all granted
        </Files>
      '';
    };
  };

  # ---------------------------------------------------------------- #
  # 3. /srv/http klasörü — m_merts yazsın diye                       #
  # ---------------------------------------------------------------- #
  systemd.tmpfiles.rules = [
    "d /srv/http 0755 m_merts users -"
  ];

  # ---------------------------------------------------------------- #
  # 4. .NET SDK                                                       #
  # ---------------------------------------------------------------- #
  environment.systemPackages = with pkgs; [
    dotnet-sdk_8
    mariadb
    adminer
  ];
}
