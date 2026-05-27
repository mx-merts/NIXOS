{ config, pkgs, lib, ... }:

{
  imports = [ ../gnix ];

  # ================================================================ #
  # KERNEL PARAMETRELERİ                                             #
  # ================================================================ #
  boot.kernelParams = [
    "slab_nomerge"             # heap spray saldırılarını zorlaştırır
    "slub_debug=FZP"           # bellek hata tespiti
    "page_poison=1"            # serbest sayfaları zehirle
    "page_alloc.shuffle=1"     # bellek tahsis sırasını karıştır
    "pti=on"                   # Meltdown koruması
    "vsyscall=none"            # eski vsyscall kapat
    "debugfs=off"              # debugfs kapat
    "oops=panic"               # kernel oops panige çevir
    "lockdown=confidentiality" # kernel lockdown
  ];

  # ================================================================ #
  # SYSCTL GÜVENLİK AYARLARI                                         #
  # ================================================================ #
  boot.kernel.sysctl = {
    "kernel.randomize_va_space"        = 2;
    "kernel.kptr_restrict"             = 2;
    "kernel.dmesg_restrict"            = 1;
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.perf_event_paranoid"       = 3;
    "kernel.yama.ptrace_scope"         = 2;
    "kernel.kexec_load_disabled"       = 1;
    "kernel.core_pattern"              = "|/bin/false";
    "fs.suid_dumpable"                 = 0;
    "fs.protected_hardlinks"           = 1;
    "fs.protected_symlinks"            = 1;
    "fs.protected_fifos"               = 2;
    "fs.protected_regular"             = 2;
    "net.ipv4.conf.all.rp_filter"            = 1;
    "net.ipv4.conf.default.rp_filter"        = 1;
    "net.ipv4.conf.all.accept_redirects"     = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects"       = 0;
    "net.ipv4.conf.all.accept_source_route"  = 0;
    "net.ipv4.tcp_syncookies"                = 1;
    "net.ipv4.tcp_timestamps"                = 0;
    "net.ipv6.conf.all.accept_redirects"     = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_source_route"  = 0;
  };

  # ================================================================ #
  # /tmp TMPFS                                                        #
  # ================================================================ #
  boot.tmp.useTmpfs    = true;
  boot.tmp.tmpfsSize   = "4G";
  boot.tmp.cleanOnBoot = true;

  # ================================================================ #
  # SWAP KAPAT                                                        #
  # ================================================================ #
  swapDevices     = lib.mkForce [];
  zramSwap.enable = false;

  # ================================================================ #
  # MAC ADRESİ RASTGELELEŞTİRME                                      #
  # ================================================================ #
  networking.networkmanager.wifi.macAddress     = "random";
  networking.networkmanager.ethernet.macAddress = "random";

  # ================================================================ #
  # DNS over TLS                                                      #
  # ================================================================ #
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  services.resolved = {
    enable      = true;
    dnssec      = "true";
    dnsovertls  = "opportunistic";
    extraConfig = ''
      DNS=1.1.1.1#cloudflare-dns.com 9.9.9.9#dns.quad9.net
      FallbackDNS=1.0.0.1#cloudflare-dns.com 149.112.112.112#dns.quad9.net
    '';
  };

  # ================================================================ #
  # APPARMOR                                                          #
  # ================================================================ #
  security.apparmor = {
    enable                    = true;
    killUnconfinedConfinables = true;
    packages                  = with pkgs; [ apparmor-profiles ];
  };

  # ================================================================ #
  # AUDIT LOGLAMA                                                     #
  # ================================================================ #
  security.audit.enable = true;
  security.audit.rules = [
    "-a exit,always -F arch=b64 -S execve"
    "-w /etc/passwd  -p wa"
    "-w /etc/shadow  -p wa"
    "-w /etc/sudoers -p wa"
    "-w /root        -p wa"
  ];
  security.auditd.enable = true;

  # ================================================================ #
  # SİBER GÜVENLİK ARAÇLARI                                          #
  # ================================================================ #
  environment.systemPackages = with pkgs; [
    nmap wireshark bettercap tcpdump mitmproxy
    metasploit sqlmap
    hashcat
    gobuster ffuf nikto
    aircrack-ng
    ghidra radare2
    theharvester subfinder
    audit lynis rkhunter
  ];
}
