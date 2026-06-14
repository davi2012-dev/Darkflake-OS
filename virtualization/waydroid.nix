{ config, pkgs, ... }: {
  # Ativa apenas o serviço do Waydroid
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
}
