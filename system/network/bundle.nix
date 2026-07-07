{ config, pkgs, ... }: {

  imports = [
    ./ssh.nix
    ./dns.nix
    ./samba.nix
    ./cockpit.nix
    ./firewall.nix
    ./analysis.nix
    ./Adguard.nix
    ./searxng.nix
    ./caddy.nix
  ];

  networking.hostName = "Darkflake";
  networking.stevenblack.enable = true;
  networking.tempAddresses = "default";
  networking.nameservers = [
    "127.0.0.1"
    "::1"
  ];
  networking.networkmanager.dns = "none";
  networking.resolvconf.enable = false;
  services.resolved.enable = false;

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    wifi.scanRandMacAddress = true;
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
  };

  services.timesyncd.enable = false;

  services.chrony = {
    enable = true;
    servers = [
      "time.cloudflare.com iburst nts require"
      "nts.netnod.se iburst nts require"
      "nts.ekspresso.se iburst nts require"
    ];
    extraConfig = ''
      server a.st1.ntp.br iburst nts require
      server b.st1.ntp.br iburst nts require
      server ptbtime1.ptb.de iburst nts require
      nts_refclocks no
      nts_timeout 5
      nts_max_attempts 3
      log nts
      nts_exclude_unsafe yes
    '';
  };
}   
