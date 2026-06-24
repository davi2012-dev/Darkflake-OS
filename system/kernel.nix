{ config, pkgs, unstable, lib, ... }:
{
boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;
boot.zfs.package = unstable.zfs;

  # --- 2. Parâmetros de Boot: Performance Bruta e Blindagem ---
  boot.kernelParams = [
    # Performance de Processamento e Latência
    "bbr3"
    "threadirqs"                    # Força threads para interrupções (ganho de latência)
    "preempt=full"                  # Preempção total para resposta instantânea
    "skew_tick=1"                   # Ajuda em CPUs com jitter de clock
    "nosoftlockup"                  # Ganho em cargas extremas
    "kvm.intel_nested=1"            # Virtualização aninhada Intel
    "kvm.amd_nested=1"              # Virtualização aninhada AMD
    "intel_pstate=active"           # Driver de performance Intel
    "psi=1"                         # Pressure Stall Information ativo
    "transparent_hugepage=madvise"  # Alocação inteligente de Huge Pages
    "lru_gen=1"                     # Multi-Gen LRU ativo (melhora paginação sob estresse)
    "panic=10"                      # Reboot automático após 10s de Kernel Panic
    "nmi_watchdog=0"                # Desativa watchdog para liberar ciclos de CPU
    "memory_hotplug=on"

    # Silenciar o Boot (Clean Boot / Flicker-Free)
    "quiet"
    "splash"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "rd.udev.log_priority=3"
    "vt.global_cursor_default=0" 

    # Hardening do Kernel (Segurança)
    "slab_nomerge"                  # Impede fusão de caches slab (trava ataques de heap)
    "page_alloc.shuffle=1"          # Randomização de RAM (ASLR no hardware)
    "vsyscall=none"                 # Mata syscalls obsoletas que são vetores de ataque
    "debugfs=off"                   # Fecha a porta para ferramentas de depuração maliciosas
    "randomize_kstack_offset=on"    # Proteção extra contra estouro de pilha
    "init_on_alloc=1"               # Zera páginas de memória ao alocar
    "init_on_free=1"                # Zera páginas de memória ao liberar
    "page_poisoning=off"
    "module.sig_enforce=1"   
    "mce=on"                        # Machine Check Exception ativo
    "ras=on"                        # Reliability, Availability, and Serviceability
    "lockdown=confidentiality"      # Impede o espaço de usuário de extrair dados do kernel
    "mitigations=auto"              # Mitigações de CPU padrão
    "intel_iommu=on"                # Isolamento de hardware IOMMU
    "iommu=pt"                      # Performance de IOMMU em modo pass-through
  ];

  # --- 3. Carga de Módulos do Kernel ---

  boot.kernelModules = [
    # Suporte Completo às VMs (VirtIO, Redes e Armazenamento)
    "virtio_pci" "virtio_blk" "virtio_gpu" "xen-blkfront" "xen-netfront" "xen-pciback"
    "wireguard" "qxl" "tap" "uhci_hcd" "ehci_hcd" "nvme" "sd_mod" "tcp_bbr3"
    "kvm-intel" "tun" "bridge" "vhost_net" "macvlan" "ipvlan" "bonding" "8021q"
    "tpm_tis" "tpm_crb" "sch_htb" "sch_ingress" "sch_fq" "sch_fq_codel" "binder_linux"

    # Controles, Input e Hardware Gamer
    "uinput" "joydev" "evdev" "hid_generic" "ahci" "9pnet_virtio" "9p" "9pnet"

    # Áudio, Monitores e Periféricos
    "snd_seq" "i2c_dev" "snd_hda_intel" "snd_usb_audio" "snd_aloop" "hidp"

    # Sensores e Monitoramento
    "coretemp" "it87" "nct6775" "intel_rapl_common"

    # Armazenamento e Sistemas de Arquivos
    "iso9660" "vfat" "ntfs3" "fuse" "crypto_user" "dm_mod" "loop" "squashfs" "overlay" "btrfs" "uas" "usb_storage" "xhci_pci" "thunderbolt" "veth" "zfs"
    "amdgpu"                        # Driver nativo de código aberto para a sua RX 550

    # PCI Passthrough (VMs com GPU dedicada)
    "vfio" "vfio_iommu_type1" "vfio_pci"
  ];

  # --- 4. Sysctl: Otimizações de Performance Geral e Memória ---
  boot.kernel.sysctl = {
    # Performance de I/O, Memória e Cache
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
    "kernel.io_uring_disabled" = 0;             
    "vm.nr_hugepages" = 0;
    "vm.transparent_hugepage" = "madvise";
    "vm.transparent_hugepage_defrag" = "defer+madvise";
    "vm.max_map_count" = 2147483642;               
    "vm.compaction_proactiveness" = 0;          
    "vm.lru_gen_stats" = 2;

    # Ajustes do Motor KSM
    "vm.ksm_max_page_sharing" = 256;
    "vm.ksm_scan_delay_millisecs" = 20;
    "vm.ksm_pages_to_scan" = 100;
    "vm.ksm_merge_across_nodes" = 0;

    # Hardening Focado em Memória e Exploit Protection (Cobrado pelo Lynis)
    "net.core.bpf_jit_harden" = 2;
    "vm.memory_failure_recovery" = 1;
    "vm.memory_failure_early_kill" = 0;
    "vm.mmap_rnd_compat_bits" = 16;
    "vm.mmap_rnd_bits" = 32;
    "vm.mmap_min_addr" = 65536;
    "abi.vsyscall32" = 0;  
    "kernel.printk" = "3 3 3 3";
    "kernel.yama.ptrace_scope" = 1;              
    "dev.tty.ldisc_autoload" = 0;
    "kernel.kexec_load_disabled" = 1;
    "kernel.unprivileged_bpf_disabled" = 1;      
    "vm.unprivileged_userfaultfd" = 0;
    "kernel.kptr_restrict" = 2;                  
    "kernel.sysrq" = 4;                          
    "kernel.random.urandom_min_reseed_secs" = 60;
    "kernel.randomize_va_space" = 2;              
    "fs.protected_fifos" = 2;
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_regular" = 2;
    "fs.suid_dumpable" = 0;
    "dev.tty.legacy_tiocsti" = 0;
    "fs.proc_can_see_other_uid" = 0;             
    "kernel.dmesg_restrict" = 1;                 
  };

  # --- 5. Blacklist de Módulos (Protocolos inseguros/legados) ---
  boot.blacklistedKernelModules = [ 
    "ax25" "netrom" "rose" "dccp" "sctp" "rds" "tipc" 
    "hfs" "hfsplus" "jffs2"                          
    "firewire-core"                                  
  ];

  # --- 6. Serviços Otimizados (Redis via Unix Sockets) ---
  services.redis.servers."meu-banco" = {
    enable = true;
    port = 0;                                       
    unixSocket = "/run/redis-meu-banco/redis.sock"; 
    unixSocketPerm = 660;                           
  };

  # --- 7. Firmware, Gráficos e Segurança de Imagem ---
  security.unprivilegedUsernsClone = true;      
  security.lockKernelModules = true;           
  security.forcePageTableIsolation = true;      
  security.protectKernelImage = true;
  
  # Gráficos da GPU AMD RX 550
  hardware.amdgpu.initrd.enable = true;          
  
  # Gerenciamento de Hardware e RAM
  hardware.ksm.enable = true;                    
  hardware.cpu.intel.updateMicrocode = true;    
  hardware.enableRedistributableFirmware = true;       
  hardware.firmwareCompression = "zstd";
  hardware.wirelessRegulatoryDatabase = true;
  hardware.cpu.x86.msr.enable = true;
  hardware.cpu.x86.msr.group = "wheel";
  hardware.cpu.x86.msr.settings.allow-writes = "off";
  hardware.cpu.x86.msr.mode = "0640";
  hardware.cpu.intel.sgx.enableDcapCompat = true;
  hardware.brillo.enable = true;
  hardware.amdgpu.zluda.enable = true;
  hardware.intel-gpu-tools.enable = true;

  # Segurança adicionais de Ferramentas
  programs.tmux.secureSocket = true;            
}
