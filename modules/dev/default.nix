{ config, pkgs, lib, ... }:

{
  imports = [ ../gnix ];

  environment.systemPackages = with pkgs; [
    # ── Ağ & Trafik ─────────────────────────────────────────── #
    nmap
    wireshark
    bettercap
    tcpdump
    mitmproxy

    # ── Exploitation ────────────────────────────────────────── #
    metasploit
    sqlmap

    # ── Şifre Kırma ─────────────────────────────────────────── #
    hashcat
    john
    thc-hydra

    # ── Web ─────────────────────────────────────────────────── #
    gobuster
    ffuf
    nikto

    # ── Kablosuz ────────────────────────────────────────────── #
    aircrack-ng

    # ── Tersine Mühendislik ──────────────────────────────────── #
    ghidra
    radare2

    # ── Recon ───────────────────────────────────────────────── #
    theharvester
    subfinder
  ];
}
