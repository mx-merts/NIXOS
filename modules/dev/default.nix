{ config, pkgs, lib, ... }:

{
  imports = [ ../gnix ];

  # ================================================================ #
  #        CODEX — PARANOİD GÜVENLİK KATMANI                        #
  # ================================================================ #

  # ---------------------------------------------------------------- #
  # 1. HARDENED KERNEL                                               #
  # ---------------------------------------------------------------- #
  boot.kernelPackages = pkgs.linuxPackages_hardened;

  # ---------------------------------------------------------------- #
  # 2. KERNEL PARAMETRELERİ                                          #
  # ---------------------------------------------------------------- #
  boot.kernelParams = [
    "slab_nomerge"          # heap spray saldırılarını zorlaştırır
    "slub_debug=FZP"        # bellek hataları tespiti
    "page_poison=1"         # serbest bırakılan sayfaları zehirle
    "page_alloc.shuffle=1"  # bellek tahsis sırasını karıştır
    "pti=on"                # Meltdown koruması (PTI)
    "vsyscall=none"         # eski vsyscall arayüzünü kapat
    "debugfs=off"           # debugfs kapat
    "oops=panic"            # kernel oops → panik (exploit önleme)
    "module.sig_enforce=1"  # imzasız kernel modülü yükleme
    "lockdown=confidentiality" # kernel lockdown modu
  ];

  # ---------------------------------------------------------------- #
  # 3. SYSCTL GÜVENLİK AYARLARI                                     #
  # ---------------------------------------------------------------- #
  boot.kernel.sysctl = {
    # Bellek koruması
    "kernel.randomize_va_space"   = 2;    # tam ASLR
    "kernel.kptr_restrict"        = 2;    # kernel pointer gizle
    "kernel.dmesg_restrict"       = 1;    # dmesg sadece root
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.perf_event_paranoid"  = 3;    # perf eventi kısıtla
    "kernel.yama.ptrace_scope"    = 2;    # ptrace sadece root
    "kernel.kexec_load_disabled"  = 1;    # kexec kapat

    # Core dump kapat
    "kernel.core_pattern"         = "|/bin/false";
    "fs.suid_dumpable"            = 0;

    # Ağ güvenliği
    "net.ipv4.conf.all.rp_filter"          = 1;  # spoofing koruması
    "net.ipv4.conf.default.rp_filter"      = 1;
    "net.ipv4.conf.all.accept_redirects"   = 0;  # ICMP redirect reddet
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.send_redirects"     = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.tcp_syncookies"              = 1;  # SYN flood koruması
    "net.ipv4.tcp_timestamps"              = 0;  # uptime sızdırma
    "net.ipv6.conf.all.accept_redirects"   = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;

    # Dosya sistemi
    "fs.protected_hardlinks"  = 1;
    "fs.protected_symlinks"   = 1;
    "fs.protected_fifos"      = 2;
    "fs.protected_regular"    = 2;
  };

  # ---------------------------------------------------------------- #
  # 4. /tmp TMPFS (RAM'de, reboot'ta siliniyor)                      #
  # ---------------------------------------------------------------- #
  boot.tmp.useTmpfs   = true;
  boot.tmp.tmpfsSize  = "4G";
  boot.tmp.cleanOnBoot = true;

  # ---------------------------------------------------------------- #
  # 5. SWAP KAPAT                                                    #
  # ---------------------------------------------------------------- #
  swapDevices = lib.mkForce [];
  zramSwap.enable = false;

  # ---------------------------------------------------------------- #
  # 6. MAC ADRESİ RASTGELELEŞTİRME                                   #
  # ---------------------------------------------------------------- #
  networking.networkmanager.wifi.macAddress    = "random";
  networking.networkmanager.ethernet.macAddress = "random";

  # ---------------------------------------------------------------- #
  # 7. DNS over TLS (Cloudflare + Quad9)                             #
  # ---------------------------------------------------------------- #
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  services.resolved = {
    enable    = true;
    dnssec    = "true";
    dnsovertls = "opportunistic";
    extraConfig = ''
      DNS=1.1.1.1#cloudflare-dns.com 9.9.9.9#dns.quad9.net
      FallbackDNS=1.0.0.1#cloudflare-dns.com 149.112.112.112#dns.quad9.net
    '';
  };

  # ---------------------------------------------------------------- #
  # 8. SIKILAŞTIRILMIŞ APPARMOR                                      #
  # ---------------------------------------------------------------- #
  security.apparmor = {
    enable                   = true;
    killUnconfinedConfinables = true;
    packages                 = with pkgs; [ apparmor-profiles ];
  };

  # ---------------------------------------------------------------- #
  # 9. AUDIT LOGLAMA                                                 #
  # ---------------------------------------------------------------- #
  security.audit.enable = true;
  security.audit.rules  = [
    "-a exit,always -F arch=b64 -S execve"         # komut çalıştırma
    "-w /etc/passwd -p wa"                          # kullanıcı değişikliği
    "-w /etc/shadow -p wa"                          # şifre değişikliği
    "-w /etc/sudoers -p wa"                         # sudo değişikliği
    "-w /root -p wa"                                # root dizini
  ];
  security.auditd.enable = true;

  # ---------------------------------------------------------------- #
  # 11. SİBER GÜVENLİK ARAÇLARI                                      #
  # ---------------------------------------------------------------- #
  environment.systemPackages = with pkgs; [
    # ── Ağ & Trafik ────────────────────────────────────────────── #
    nmap
    wireshark
    bettercap
    tcpdump
    mitmproxy

    # ── Exploitation ───────────────────────────────────────────── #
    metasploit
    sqlmap

    # ── Şifre Kırma ────────────────────────────────────────────── #
    hashcat

    # ── Web ────────────────────────────────────────────────────── #
    gobuster
    ffuf
    nikto

    # ── Kablosuz ───────────────────────────────────────────────── #
    aircrack-ng

    # ── Tersine Mühendislik ────────────────────────────────────── #
    ghidra
    radare2

    # ── Recon ──────────────────────────────────────────────────── #
    theharvester
    subfinder

    # ── Audit & İzleme ─────────────────────────────────────────── #
    audit
    lynis        # sistem güvenlik denetimi
    rkhunter     # rootkit tarayıcı
  ];
}
