{ config, pkgs, lib, ... }: {
  virtualisation.lxc = {
    enable = true;
    unprivilegedContainers = true;
    lxcfs.enable = true;
    defaultConfig = "lxc.include = ${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf";
  };
}
