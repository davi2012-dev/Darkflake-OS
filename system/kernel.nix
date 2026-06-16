{ config, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_zen;
  
  # --- 2. Parâmetros de Boot: Performance Bruta e Blindagem ---
  boot.kernelParams = [
    # Performance de Processamento e Latência
    "threadirqs"                   # Força threads para interrupções (ganho de latência)
    "preempt=full"                 # Preempção total para resposta instantânea
    "skew_tick=1"                  # Ajuda em CPUs com jitter de clock
    "nosoftlockup"                 # Ganho em cargas extremas
    "kvm.intel_nested=1"           # Virtualização aninhada Intel
    "kvm.amd_nested=1"             # Virtualização aninhada AMD
    "intel_pstate=active"          # Driver de performance Intel
    "psi=1"                        # Pressure Stall Information ativo
    "transparent_hugepage=madvise" # Alocação inteligente de Huge Pages
    "lru_gen=1"                    # Multi-Gen LRU ativo (melhora paginação sob estresse)
    "panic=10"                     # Reboot automático após 10s de Kernel Panic
    "nmi_watchdog=0"               # Desativa watchdog para liberar ciclos de CPU
    "memory_hotplug=on"

    # Silenciar o Boot (Clean Boot)
    "quiet"
    "splash"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "rd.udev.log_priority=3"
    "vt.global_cursor_default=0" 

    # Hardening do Kernel (Segurança)
    "slab_nomerge"                 # Impede fusão de caches slab (trava ataques de heap)
    "page_alloc.shuffle=1"         # Randomização de RAM (ASLR no hardware)
    "vsyscall=none"                # Mata syscalls obsoletas que são vetores de ataque
    "debugfs=off"                  # Fecha a porta para ferramentas de depuração maliciosas
    "randomize_kstack_offset=on"   # Proteção extra contra estouro de pilha
    "init_on_alloc=1"              # Zera páginas de memória ao alocar
    "init_on_free=1"               # Zera páginas de memória ao liberar
    "page_poisoning=off"
    "module.sig_enforce=1"   
    "mce=on"                       # Machine Check Exception ativo
    "ras=on"                       # Reliability, Availability, and Serviceability
    "lockdown=confidentiality"     # Impede o espaço de usuário de extrair dados do kernel
    "mitigations=auto"             # Mitigações de CPU padrão (mude para 'off' se quiser máxima performance a custo de segurança)
    "intel_iommu=on"               # Isolamento de hardware IOMMU
    "iommu=pt"                     # Performance de IOMMU em modo pass-through
  ];

  # --- 3. Carga de Módulos do Kernel ---
  boot.kernelModules = [
    # =========================================================================
    # 🚀 ADICIONADOS PARA SUPORTE COMPLETO ÀS VMs (VIRTIO, 9P, GRAFICOS E USB)
    # =========================================================================
    "virtio_pci"          # Barramento virtualizado essencial para mapear o hardware
    "virtio_blk"          # Driver do Disco Rápido Virtual (diskInterface = "virtio")
    "virtio_gpu"          # Aceleração gráfica moderna do QEMU dentro da VM
    "qxl"                 # Driver de vídeo básico alternativo para a janela gráfica
    "tap"                 # Necessário para os túneis de rede da interface virtual
    "uhci_hcd"            # Controladora USB (Essencial para o spiceUSBRedirection)
    "ehci_hcd"            # Controladora USB 2.0 para redirecionamento estável
    "nvme"                # Driver para o seu SSD real M.2 caso o host precise
    "sd_mod"              # Módulo básico de gerenciamento de discos do sistema
    # =========================================================================

    # --- Virtualização, Containers e Redes ---
    "kvm-intel"           # Aceleração Intel (mude para "k10temp" / "kvm-amd" se sua CPU for AMD)
    "tun"                 # VPNs (Tailscale, WireGuard)
    "bridge"              # Redes em ponte (Docker/Virt-Manager)
    "vhost_net"           # Performance de rede em VMs
    "macvlan"             # Redes macvlan para containers
    "ipvlan"
    "bonding"
    "8021q"               # VLANs
    "tpm_tis"
    "tpm_crb"
    "sch_htb"
    "sch_ingress"
    "sch_fq"
    "sch_fq_codel"

    # --- Controles, Input e Hardware Gamer ---
    "uinput"              # OpenRGB, Controles Virtuais, Emuladores
    "joydev"              # Joysticks clássicos
    "evdev"               # Input avançado
    "hid_generic"
    "ahci"
    "9pnet_virtio"
    "9p"
    "9pnet"

    # --- Áudio, Monitores e Periféricos ---
    "snd_seq"             # MIDI
    "i2c_dev"             # Controle de brilho DDC/CI e RGB de placas-mãe
    "snd_hda_intel"       # Áudio integrado
    "snd_usb_audio"       # Interfaces de som USB
    "snd_aloop"           # Loopback de áudio (OBS Studio)
    "hidp"

    # --- Sensores e Monitoramento ---
    "coretemp"            # Temperatura CPU Intel (Mude para "k10temp" se for AMD)
    "it87"                # Sensores de ventoinha/tensão
    "nct6775"             # Sensores Nuvoton comuns em desktops
    "intel_rapl_common"   # Telemetria de energia Intel

   # --- Armazenamento e Sistemas de Arquivos ---
    "iso9660"
    "vfat"
    "ntfs3"               # Driver NTFS moderno
    "fuse"                # Flatpaks, AppImages, Rclone
    "crypto_user"         # Criptografia LUKS
    "dm_mod"              # LVM / LUKS
    "loop"                # Montagem de ISOs / Flatpak
    "squashfs"            # Snaps e AppImages
    "overlay"             # Docker OverlayFS
    "btrfs"               # Se usar Btrfs
    "uas"                 # USB Attached SCSI (SSDs Externos rápidos)
    "usb_storage"
    "xhci_pci"            # Controladoras USB 3.x
    "thunderbolt"         # Suporte a portas Thunderbolt
    "veth"
    "zfs"
    "amdgpu"

    # --- PCI Passthrough (VMs com GPU dedicada) ---
    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"
  ];

  # --- 4. Sysctl: Otimizações de Performance e Hardening ---
  boot.kernel.sysctl = {
    # Performance de I/O, Memória e Cache
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "kernel.io_uring_disabled" = 0;             # Garante que io_uring esteja ativo (Gaming/I/O rápido)
    "vm.nr_hugepages" = 0;
    "vm.transparent_hugepage" = "madvise";
    "vm.transparent_hugepage_defrag" = "defer+madvise";
    "vm.max_map_count" = 1048576;               # Essencial para jogos pesados via Proton/Steam (ex: Cyberpunk)
    "vm.compaction_proactiveness" = 0;          # Evita gagueiras (stuttering) em background
    "vm.lru_gen_stats" = 2;
    "vm.ksm_max_page_sharing" = 256;
    "vm.ksm_scan_delay_millisecs" = 20;
    "vm.ksm_pages_to_scan" = 100;
    # Rede: Performance e Redução de Bufferbloat
    "net.core.somaxconn" = 8192;                # Maior fila de conexões para apps de rede e servidores

    # Hardening do Kernel / Proteção contra Exploit
    "vm.memory_failure_recovery" = 1;
    "vm.memory_failure_early_kill" = 0;
    "vm.mmap_rnd_compat_bits" = 16;
    "vm.mmap_rnd_bits" = 32;
    "vm.mmap_min_addr" = 65536;
    "abi.vsyscall32" = 0;  
    "kernel.printk" = "3 3 3 3";
    "kernel.yama.ptrace_scope" = 1;             # Impede processos não-filhos de espionar a memória com ptrace
    "dev.tty.ldisc_autoload" = 0;
    "kernel.kexec_load_disabled" = 1;
    "kernel.unprivileged_bpf_disabled" = 1;     # Bloqueia ataques via eBPF não privilegiado
    "vm.unprivileged_userfaultfd" = 0;
    "kernel.kptr_restrict" = 2;                 # Esconde endereços de ponteiros do kernel em /proc
    "kernel.sysrq" = 4;                         # Desativa comandos SysRq perigosos físicos (mantém apenas sync)
    "kernel.random.urandom_min_reseed_secs" = 60;
    "kernel.randomize_va_space" = 2;            # ASLR agressivo
    "fs.protected_fifos" = 2;
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = 0;
    "dev.tty.legacy_tiocsti" = 0;
    "fs.proc_can_see_other_uid" = 0;            # Usuários não veem processos uns dos olfactory
    "kernel.dmesg_restrict" = 1;                # Bloqueia leitura do dmesg para usuários comuns
  };

  # --- 5. Blacklist de Módulos (Protocolos inseguros/legados) ---
  boot.blacklistedKernelModules = [ 
    "ax25" "netrom" "rose" "dccp" "sctp" "rds" "tipc" 
    "hfs" "hfsplus" "jffs2"                          
    "firewire-core"                  
  ];

  # --- 6. Firmware e Segurança de Imagem ---
  security.unprivilegedUsernsClone = true;      # Necessário para caixas de areia do Chrome/Flatpak funcionarem
  security.lockKernelModules = true;            # Bloqueia inserção de módulos após boot (Hardening máximo)
  security.forcePageTableIsolation = true;      # Proteção contra Meltdown
  security.protectKernelImage = true;
  hardware.ksm.enable = true;
  hardware.cpu.intel.updateMicrocode = true;    # Se sua CPU for AMD, altere para hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;       
  hardware.firmwareCompression = "zstd";
  hardware.wirelessRegulatoryDatabase = true;
  programs.tmux.secureSocket = true;
}
