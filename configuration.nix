# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
    ];
boot.loader.systemd-boot = {
  enable = true;
  editor = false;
};
boot.loader.efi = {
  canTouchEfiVariables = true;
};
boot.loader.grub = {
  enable = true;
  copyKernels = true;
  efiInstallAsRemovable = false;
  efiSupport = true;
  fsIdentifier = "uuid";
  splashMode = "stretch";
  version = 2;
  device = "nodev";
  extraEntries = ''
    menuentry "Reboot" {
      reboot
    }
    menuentry "Poweroff" {
      halt
    }
  '';
};
boot.kernelParams = [ "console=ttyS0,115200 earlyprintk=serial,ttyS0,115200" ];
  # Use the GRUB 2 boot loader.
#  boot.loader.grub.enable = true;
 # boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  #boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
#   #boot.loader.grub.extraEntries = ''
#     menuentry "NixOS - Secure Launch" {
# #    search --set=drive1 --fs-uuid fdd9e92a-3d69-4bde-8c39-167ff7fba974
# #    search --set=drive2 --fs-uuid fdd9e92a-3d69-4bde-8c39-167ff7fba974
#       slaunch skinit
#       slaunch_module ($drive2)/boot/lz_header
#       linux ($drive2)/nix/store/3w98shnz1a6nxpqn2wwn728mr12dy3kz-linux-5.5.3/bzImage systemConfig=/nix/store/3adz0xnfnr71hrg84nyawg2rqxrva3x3-nixos-system-nixos-20.09.git.c156a866dd7M init=/nix/store/3adz0xnfnr71hrg84nyawg2rqxrva3x3-nixos-system-nixos-20.09.git.c156a866dd7M/init console=ttyS0,115200 earlyprintk=serial,ttyS0,115200 loglevel=4
#       initrd ($drive2)/nix/store/7q64073svk689cvk36z78zj7y2ifgjdv-initrd-linux-5.5.3/initrd
#     }
#   '';

   networking.hostName = "nixos"; # Define your hostname.
   networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  boot.kernelParams = [ "console=ttyS0,115200 earlyprintk=serial,ttyS0,115200" ];
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Asia/Kolakata";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
  #kernel modules
#  menuentry 'NixOS' {
#    insmod crypto
#    insmod cryptodisk
#    insmod luks
#    insmod lvm
#    cryptomount -u a0cb535a8468485fa220a5f49e85c9f4
#    set root='lvmid/5atKN9-PQBi-T9wb-Iyz8-qP4y-HN2E-c5uLOT/C9zkjF-IHu0-qQkP-KgLf-8rAy-TVPu-HQ7gtj'
#    search --fs-uuid --set=root cc6a06bb-336f-4e9f-a5f0-fdd43e7f548f
#    configfile '/boot/grub/grub.cfg'
#}
  # OS utilities
  environment.systemPackages = [
                                 pkgs.pkg-config
                                 pkgs.git
                                 pkgs.gnumake
                                 pkgs.autoconf
                                 pkgs.automake
                                 pkgs.gettext
                                 pkgs.python
                                 pkgs.m4
                                 pkgs.libtool
                                 pkgs.bison
                                 pkgs.flex
                                 pkgs.gcc
                                 pkgs.gcc_multi
                                 pkgs.libusb
                                 pkgs.ncurses
                                 pkgs.freetype
                                 pkgs.qemu
                                 pkgs.lvm2
                                 pkgs.unifont
                                 pkgs.fuse
                                 pkgs.gnulib
                                 pkgs.stdenv
                                 pkgs.nasm
                                 pkgs.binutils
                                 pkgs.tpm2-tools
                                 pkgs.tpm2-tss
                                 pkgs.landing-zone
                                 pkgs.landing-zone-debug
                                 pkgs.grub-tb
                                ];

  # Grub override
  nixpkgs.config.packageOverrides = pkgs: { grub2 = pkgs.grub-tb; };
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
