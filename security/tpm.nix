{ pkgs, ... }: {
  # --- Configuração do Chip TPM ---
  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    abrmd.enable = true;
    applyUdevRules = true;
  };
  # --- Ferramentas de Linha de Comando ---
  environment.systemPackages = with pkgs; [
    tpm2-tools    # Ferramentas principais para gerenciar o chip
    tpm2-tss      # Stack de software necessária para apps conversarem com o TPM
    tpm2-totp     # Se quiser gerar códigos tipo Google Authenticator baseados no chip
    tpm2-openssl
  ];
}
