{ pkgs, ... }: {

  # --- Configuração do LUKS (Criptografia no Boot) ---
  boot.initrd.luks.devices."luks-7e032019-3fff-421e-b605-87502509f174" = {
    # O UUID acima deve ser o do seu disco sda3 (visto no seu lsblk anterior)
    device = "/dev/disk/by-uuid/7e032019-3fff-421e-b605-87502509f174";
    
    # Permite o TRIM no SSD criptografado (melhora performance e vida útil)
    allowDiscards = true;

    # --- Desbloqueio Automático via TPM2 ---
    # Isso faz o NixOS tentar usar o chip TPM antes de pedir a senha
    deviceEncryptionKeyFile = null; # Usa o slot do TPM
    crypttabExtraOpts = [ "tpm2-device=auto" ];
  };

  # Necessário para o sistema entender o TPM durante o estágio inicial do boot
  boot.initrd.systemd.enable = true;
}
