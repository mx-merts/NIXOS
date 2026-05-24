{ config, pkgs, lib, ... }:

{
  # ================================================================ #
  #        EVRENSEL DONANIM MODÜLÜ — taşınabilir USB için            #
  # ================================================================ #

  # ---------------------------------------------------------------- #
  # 1. KERNEL MODÜLLERİ                                              #
  # ---------------------------------------------------------------- #
  boot.initrd.availableKernelModules = [
    "xhci_pci"    # USB 3.x kontrolcüsü
    "ahci"        # SATA HDD/SSD
    "nvme"        # M.2 NVMe SSD
    "usb_storage" # USB bellek
    "uas"         # Taşınabilir SSD yüksek hız protokolü
    "sd_mod"      # SCSI/SATA disk desteği
  ];

  # Early KMS — boot'tan itibaren doğru çözünürlük, flickering yok
  boot.initrd.kernelModules = [
    "i915"    # Intel iGPU erken başlatma
    "amdgpu"  # AMD iGPU/dGPU erken başlatma
  ];

  boot.kernelModules    = [ "kvm-intel" "kvm-amd" ];
  boot.extraModulePackages = [ ];


  # ---------------------------------------------------------------- #
  # 2. GPU SÜRÜCÜLERİ                                                #
  # ---------------------------------------------------------------- #
  # modesetting → Intel + AMD için evrensel açık kaynak sürücü
  # amdgpu      → AMD için açık kaynak sürücü (performans için)
  # fbdev       → temel grafik arayüz desteği (fallback)
  services.xserver.videoDrivers = [ "modesetting" "amdgpu" "fbdev" ];

  hardware.graphics = {
    enable      = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # Intel VA-API (donanım video hızlandırma)
      intel-media-driver  # Broadwell ve sonrası Intel GPU
      intel-vaapi-driver  # Eski Intel GPU'lar

      # AMD VA-API + Vulkan (Mesa üzerinden)
      mesa

      # VDPAU → VA-API köprüsü (video oynatma)
      libvdpau-va-gl
    ];
    # 32-bit Vulkan (Steam ve Wine için)
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
    ];
  };


  # ---------------------------------------------------------------- #
  # 3. CPU MİKROKOD GÜNCELLEMELERİ                                   #
  # ---------------------------------------------------------------- #
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.amd.updateMicrocode   = lib.mkDefault config.hardware.enableRedistributableFirmware;


  # ---------------------------------------------------------------- #
  # 4. EVRENSEL FIRMWARE                                              #
  # ---------------------------------------------------------------- #
  hardware.enableAllFirmware            = true;
  hardware.enableRedistributableFirmware = true;


  # ---------------------------------------------------------------- #
  # 5. BLUETOOTH                                                      #
  # ---------------------------------------------------------------- #
  hardware.bluetooth = {
    enable      = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # Batarya seviyesi gösterimi
  };
  services.blueman.enable = true;


  # ---------------------------------------------------------------- #
  # 6. GÜÇ YÖNETİMİ                                                  #
  # ---------------------------------------------------------------- #
  powerManagement.enable    = true;
  services.thermald.enable  = true; # Intel CPU aşırı ısınma koruması

  # ---------------------------------------------------------------- #
  # 7. EKSTRA DONANIM PAKETLERİ                                       #
  # ---------------------------------------------------------------- #
  environment.systemPackages = with pkgs; [
    pciutils   # lspci — hangi donanım var görmek için
    usbutils   # lsusb
    lshw       # tüm donanım listesi
    nvtopPackages.full  # GPU kullanımı izleme (Intel + AMD + Nvidia)
  ];
}
