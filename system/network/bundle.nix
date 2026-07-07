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
      "time.cloudflare.com iburst nts"
      "nts.netnod.se iburst nts"
      "nts.ekspresso.se iburst nts"
    ];
    extraConfig = ''
      authselectmode require
    '';
  };
}
