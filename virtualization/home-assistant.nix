{ config, pkgs, ... }: {

virtualisation.oci-containers.containers."homeassistant" = {
    image = "ghcr.io/home-assistant/home-assistant:stable";
    volumes = [
      "/var/lib/homeassistant:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environment = {
      TZ = "America/Sao_Paulo";
    };
    extraOptions = [
      "--network=host" # Crucial para o HA achar suas luzes/TVs no Wi-Fi
    ];
  };
}
