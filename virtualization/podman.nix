{ config, pkgs, ... }: {

  # Ativa o suporte geral a containers no NixOS
  virtualisation.containers.enable = true;

  # Configuração global do Podman Engine
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    
    # Faxina automática para o Kubernetes e os deploys não estourarem o SSD da VM
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  # CONFIGURAÇÃO DECLARATIVA DOS CONTAINERS (OCI)
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {

      # 1. Stirling-PDF
      stirling-pdf = {
        image = "docker.io/stirlingtools/stirling-pdf:latest";
        ports = [ "8089:8080" ];
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
      };

      # 3. MongoDB (Banco de dados do LibreChat)
      librechat-db = {
        image = "docker.io/library/mongo:latest";
        volumes = [
          "librechat_mongo_data:/data/db:Z"
        ];
      };

      # 4. LibreChat Principal
      librechat = {
        image = "ghcr.io/danny-avila/librechat:latest";
        ports = [ "3080:3080" ];
        environment = {
          MONGO_URI = "mongodb://librechat-db:27017/LibreChat";
          CONFIG_BYPASS_VALIDATION = "true";
          CREW_SECRET = "ZkahHL3KRtZ5JT/N9lGqqFoERSFLkK6F92nk9GPhYQ4=";
          JWT_SECRET = "+7glROSrzmEs+/YfRr7dBtk4Rc8LLrI81dsxN8Gp8qE=";
          REFRESH_TOKEN_SECRET = "1UQiAma+QslvZMFSQUdwDChqy3UeBeUnoHtN1Atp0kc=";
          ALLOW_REGISTRATION = "true";
        };
        dependsOn = [ "librechat-db" ];
      };

      # 5. MariaDB (Banco de dados do Nextcloud)
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
      };

      # 6. Nextcloud Principal
      nextcloud = {
        image = "docker.io/library/nextcloud:latest";
        ports = [ "8085:80" ];
        environment = {
          MYSQL_HOST = "nextcloud-db";
          MYSQL_DATABASE = "nextcloud";
          MYSQL_USER = "nextcloud";
          MYSQL_PASSWORD = "sua_senha_nextcloud_aqui";
          NEXTCLOUD_TRUSTED_DOMAINS = "localhost nextcloud.Darkflake.local Darkflake.local";
        };
        volumes = [
          "nextcloud_data:/var/www/html:Z"
        ];
        dependsOn = [ "nextcloud-db" ];
      };

      # 7. Homarr (Dashboard)
      homarr = {
        image = "ghcr.io/homarr-labs/homarr:latest";
        ports = [ "8083:7575" ];
        environment = {
          SECRET_ENCRYPTION_KEY = "28fc6b3f07d57c4d4349bd976ad5d247aef82d2e3afe3e78dced7444d374e7bd";
        };
        volumes = [
          "homarr_configs:/app/data/configs:Z"
          "homarr_data:/data:Z"
        ];
      };

      # 8. Jellyfin (Com repasse de aceleração de vídeo por hardware)
      jellyfin = {
        image = "docker.io/jellyfin/jellyfin:latest";
        ports = [ "8096:8096" ];
        volumes = [
          "/home/jellyfin/config:/config:Z"
          "/home/jellyfin/media:/media:Z"
          "/home/jellyfin/cache:/cache:Z"
          "/home/jellyfin/media/youtube:/youtube:Z"
        ];
        extraOptions = [ "--device=/dev/dri:/dev/dri" ];
      };

      # 9. MeTube (Direcionado para a pasta de mídias do Jellyfin)
      metube = {
        image = "ghcr.io/alexta69/metube:latest";
        ports = [ "8081:8081" ];
        volumes = [
          "/home/jellyfin/media/youtube:/youtube:Z"
        ];
      };

      # 10. Netdata Hardened Ajustado (Segurança Avançada e Monitoramento)
      netdata = {
        image = "docker.io/netdata/netdata:stable";
        ports = [ "19999:19999" ];
        extraOptions = [
          "--cap-add=SYS_PTRACE"                  # Permite monitorar os processos do host
          "--security-opt=no-new-privileges:true" # Impede elevação de privilégios dentro do container
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

      # 11. Home Assistant (Injetado com sucesso no ecossistema)
      homeassistant = {
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
      # 12. Databag - Chat auto-hospedado para família
     databag = {
       image = "docker.io/balzack/databag:latest";
      ports = [ "7000:7000" ];  # porta HTTP (pode mudar se quiser)
      environment = {
      DOMAIN = "chat.Darkflake.local";
      TRUSTED_PROXIES = "127.0.0.1";
      SECRET = "77d44da1481f6c2765cc211a63728961684fb4d49e8f20a3b7b5da81f8e0e2ed";

    # (Opcional) Se quiser usar HTTPS com certificado próprio, veja a doc
    # TLS_CERT = "/caminho/para/cert.pem";
    # TLS_KEY  = "/caminho/para/key.pem";
  };
  volumes = [
    "databag_data:/home/app/data:Z"   # persistência dos dados
  ];
  extraOptions = [
    # Para garantir que o container possa se comunicar com a rede do host se necessário
    # (mas normalmente não precisa)
  ];
};

    };
  };

  # Ferramentas auxiliares instaladas no sistema para gerenciar e debugar os containers
  environment.systemPackages = with pkgs; [
    podman-compose
    podman-tui
    dive
  ];
}
