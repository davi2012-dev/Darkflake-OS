{ config, pkgs, ... }: {

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = false;  

    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {

      # 1. Stirling-PDF
      stirling-pdf = {
        image = "docker.io/stirlingtools/stirling-pdf:latest";
        ports = [ "8089:8080" ];
        extraOptions = [ "--dns=10.88.0.1" ];
      };

      # 2. Portainer
      portainer = {
        image = "docker.io/portainer/portainer-ce:latest";
        ports = [
          "8000:8000"
          "9443:9443"
        ];
        volumes = [
          "/run/podman/podman.sock:/var/run/docker.sock:Z"
          "portainer_data:/data:Z"
        ];
        extraOptions = [ "--dns=10.88.0.1" ];
      };

      # 3. MariaDB (Nextcloud)
      nextcloud-db = {
        image = "docker.io/library/mariadb:latest";
        environment = {
          MYSQL_ROOT_PASSWORD = "sua_senha_root_aqui";
          MYSQL_DATABASE = "nextcloud";
          MYSQL_USER = "nextcloud";
          MYSQL_PASSWORD = "sua_senha_nextcloud_aqui";
        };
        volumes = [
          "nextcloud_db_data:/var/lib/mysql:Z"
        ];
        extraOptions = [ "--dns=10.88.0.1" ];
      };

      # 4. Nextcloud
      nextcloud = {
        image = "docker.io/library/nextcloud:latest";
        ports = [ "8085:80" ];
        extraOptions = [ "--dns=10.88.0.1" ];
        environment = {
          MYSQL_HOST = "nextcloud-db";
          MYSQL_DATABASE = "nextcloud";
          MYSQL_USER = "nextcloud";
          MYSQL_PASSWORD = "sua_senha_nextcloud_aqui";
          TRUSTED_PROXIES = "127.0.0.1";
        };
        volumes = [
          "nextcloud_data:/var/www/html:Z"
        ];
        dependsOn = [ "nextcloud-db" ];
      };

      # 5. Jellyfin
      jellyfin = {
        image = "docker.io/jellyfin/jellyfin:latest";
        ports = [ "8096:8096" ];
        extraOptions = [
          "--dns=10.88.0.1"
          "--device=/dev/dri:/dev/dri"
        ];
        volumes = [
          "/home/jellyfin/config:/config:Z"
          "/home/jellyfin/media:/media:Z"
          "/home/jellyfin/cache:/cache:Z"
          "/home/jellyfin/media/youtube:/youtube:Z"
        ];
      };

      # 6. MeTube
      metube = {
        image = "ghcr.io/alexta69/metube:latest";
        ports = [ "8081:8081" ];
        extraOptions = [ "--dns=10.88.0.1" ];
        volumes = [
          "/home/jellyfin/media/youtube:/youtube:Z"
        ];
      };

      # 7. Netdata
      netdata = {
        image = "docker.io/netdata/netdata:stable";
        ports = [ "19999:19999" ];
        extraOptions = [
          "--dns=10.88.0.1"
          "--cap-add=SYS_PTRACE"
          "--security-opt=no-new-privileges:true"
        ];
        volumes = [
          "netdata_config:/etc/netdata:Z"
          "netdata_lib:/var/lib/netdata:Z"
          "netdata_cache:/var/cache/netdata:Z"
          "/proc:/host/proc:ro"
          "/sys:/host/sys:ro"
          "/etc/os-release:/host/etc/os-release:ro"
        ];
      };

      # 8. Home Assistant
      homeassistant = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        extraOptions = [
          "--dns=10.88.0.1"
          "--network=host"
        ];
        volumes = [
          "/var/lib/homeassistant:/config"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TRUSTED_PROXIES = "127.0.0.1";
          TZ = "America/Sao_Paulo";
        };
      };

      # 9. Databag
      databag = {
        image = "docker.io/balzack/databag:latest";
        ports = [ "7000:7000" ];
        extraOptions = [ "--dns=10.88.0.1" ];
        environment = {
          DOMAIN = "chat.Darkflake.local";
          TRUSTED_PROXIES = "127.0.0.1";
          SECRET = "77d44da1481f6c2765cc211a63728961684fb4d49e8f20a3b7b5da81f8e0e2ed";
        };
        volumes = [
          "databag_data:/home/app/data:Z"
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    podman-tui
    dive
  ];
}
