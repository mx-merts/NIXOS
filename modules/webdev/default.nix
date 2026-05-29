{ config, pkgs, ... }:

{
  # ================================================================ #
  #  WEBDEV MODÜLÜ — MariaDB · Apache · PHP · phpMyAdmin · .NET      #
  # ================================================================ #

  # ---------------------------------------------------------------- #
  # 1. MARİADB (MySQL uyumlu)                                        #
  # ---------------------------------------------------------------- #
  services.mysql = {
    enable  = true;
    package = pkgs.mariadb;
  };

  # ---------------------------------------------------------------- #
  # 2. APACHE + PHP                                                   #
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
  
          Alias /phpmyadmin ${pkgs.phpmyadmin}/share/phpmyadmin
          <Directory "${pkgs.phpmyadmin}/share/phpmyadmin">
            AllowOverride All
            Require all granted
          </Directory>
        '';
      };
      };
    };



  # ---------------------------------------------------------------- #
  # 4. /srv/http klasörü — m_merts yazsın diye                       #
  # ---------------------------------------------------------------- #
  systemd.tmpfiles.rules = [
    "d /srv/http 0755 m_merts users -"
  ];

  # ---------------------------------------------------------------- #
  # 5. .NET SDK                                                       #
  # ---------------------------------------------------------------- #
 environment.systemPackages = with pkgs; [
    dotnet-sdk_8
    mariadb
    phpmyadmin
  ];
