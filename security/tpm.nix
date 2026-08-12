{ pkgs, ... }: {

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    abrmd.enable = true;
    applyUdevRules = true;
  };

  environment.systemPackages = with pkgs; [
    tpm2-tools    
    tpm2-tss     
    tpm2-totp    
    tpm2-openssl
  ];
}
