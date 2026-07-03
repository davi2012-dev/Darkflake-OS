{ config, pkgs, unstable, lib, ... }:
{
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore;
  boot.zfs.package = unstable.zfs;

  # --- 2. Parâmetros de Boot ---
  boot.kernelParams = [
    "bbr3"
    "numa_balancing=enable"
    "cpuidle.governor=teo"
    "threadirqs"
    "preempt=full"
    "skew_tick=1"
    "nosoftlockup"
    "kvm.intel_nested=1"
    "kvm.amd_nested=1"
    "intel_pstate=active"
    "psi=1"
    "transparent_hugepage=madvise"
    "lru_gen=1"
    "panic=10"
    "nmi_watchdog=0"
    "memory_hotplug=on"
    "ksm.max_page_sharing=256"
    "ksm.pages_to_scan=100"
    "ksm.merge_across_nodes=0"

    # Silenciar o Boot
    "quiet"
    "splash"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "rd.udev.log_priority=3"
    "vt.global_cursor_default=0"

    # Hardening do Kernel
    "slab_nomerge"
    "page_alloc.shuffle=1"
    "vsyscall=none"
    "debugfs=off"
    "randomize_kstack_offset=on"
    "init_on_alloc=1"
    "init_on_free=1"
    "page_poisoning=off"
    "module.sig_enforce=1"
    "xen_msr_safe=1"
    "xen_scrub_pages=1"
    "mce=on"
    "ras=on"
    "lockdown=confidentiality"
    "mitigations=auto"
    "intel_iommu=on"
    "iommu=pt"
  ];

  # --- 3. Módulos do Kernel ---
  boot.kernelModules = [
    "virtio_pci" "virtio_blk" "virtio_gpu" "xen-blkfront" "xen-netfront" "xen-pciback"
    "wireguard" "qxl" "tap" "uhci_hcd" "ehci_hcd" "nvme" "sd_mod" "tcp_bbr3"
    "kvm-intel" "tun" "bridge" "vhost_net" "macvlan" "ipvlan" "bonding" "8021q"
    "tpm_tis" "tpm_crb" "sch_htb" "sch_ingress" "sch_fq" "sch_fq_codel" "binder_linux"
    "uinput" "joydev" "evdev" "hid_generic" "ahci" "9pnet_virtio" "9p" "9pnet"
    "snd_seq" "i2c_dev" "snd_hda_intel" "snd_usb_audio" "snd_aloop" "hidp"
    "coretemp" "it87" "nct6775" "intel_rapl_common"
    "iso9660" "vfat" "ntfs3" "fuse" "crypto_user" "dm_mod" "loop" "squashfs" "overlay" "btrfs" "uas" "usb_storage" "xhci_pci" "thunderbolt" "veth" "zfs"
    "amdgpu"
    "vfio" "vfio_iommu_type1" "vfio_pci"
  ];

  # --- 4. Sysctl (Apenas o que NÃO está no swap.nix) ---
  boot.kernel.sysctl = {
    # Performance de I/O, Memória e Cache
    "vm.vfs_cache_pressure" = 50;
    "kernel.io_uring_disabled" = 0;
    "vm.nr_hugepages" = 0;
    "vm.transparent_hugepage" = "madvise";
    "vm.transparent_hugepage_defrag" = "defer+madvise";
    "vm.max_map_count" = 2147483642;
    "vm.compaction_proactiveness" = 0;
    "vm.lru_gen_stats" = 2;
    "vm.overcommit_memory" = lib.mkForce 2;      
    "vm.overcommit_ratio" = 99;
    "vm.min_free_kbytes" = 65536;
    "vm.zone_reclaim_mode" = 0;
    "vm.oom_dump_tasks" = 0;
    "kernel.perf_event_paranoid" = 3;

    # Hardening
    "net.core.bpf_jit_harden" = 2;
    "vm.memory_failure_recovery" = 1;
    "vm.memory_failure_early_kill" = 0;
    "vm.mmap_rnd_compat_bits" = 16;
    "vm.mmap_rnd_bits" = 32;
    "vm.mmap_min_addr" = 65536;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.ipv4.tcp_mem" = "786432 1048576 1572864";
    "net.ipv4.udp_mem" = "786432 1048576 1572864";
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

  # --- 5. Blacklist ---
  boot.blacklistedKernelModules = [
    "ax25" "netrom" "rose" "dccp" "sctp" "rds" "tipc"
    "hfs" "hfsplus" "jffs2"
    "firewire-core"
  ];

  # --- 6. Redis ---
  services.redis.servers."unified" = {
    enable = true;
    port = 0;
    unixSocket = "/run/redis-unified/redis.sock";
    unixSocketPerm = 660;
  };

  # --- 7. Hardware ---
  security.unprivilegedUsernsClone = true;
  security.lockKernelModules = false;
  security.forcePageTableIsolation = false;
  security.protectKernelImage = true;
  security.auditd.enable = true;

  hardware.amdgpu.initrd.enable = true;
  hardware.ksm = {
    enable = true;
    sleep = 20;
  };
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

  programs.tmux.secureSocket = true;
}
