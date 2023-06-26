# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-b15911cd-9a90-4d5e-877e-92eb361aae95".device = "/dev/disk/by-uuid/b15911cd-9a90-4d5e-877e-92eb361aae95";
  boot.initrd.luks.devices."luks-b15911cd-9a90-4d5e-877e-92eb361aae95".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Guatemala";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_GT.UTF-8";
    LC_IDENTIFICATION = "es_GT.UTF-8";
    LC_MEASUREMENT = "es_GT.UTF-8";
    LC_MONETARY = "es_GT.UTF-8";
    LC_NAME = "es_GT.UTF-8";
    LC_NUMERIC = "es_GT.UTF-8";
    LC_PAPER = "es_GT.UTF-8";
    LC_TELEPHONE = "es_GT.UTF-8";
    LC_TIME = "es_GT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.agua = {
    isNormalUser = true;
    description = "Agua";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    mullvad-vpn
    brave
    evolution
    vlc
    rstudioWrapper
    zotero
    libreoffice
    neovim
    keepassxc
    gnome.gnome-tweaks
    element-desktop
    signal-desktop
    freetube
    calibre
    anki
    albert
    marktext
    czkawka
    dupeguru
    git
    meld
    cryptomator
    transmission-qt
    mullvad-browser
    rPackages.tidyverse
    zettlr
    gimp-with-plugins
    unetbootin
    tutanota-desktop
    appimage-run
    joplin-desktop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Mullvad option/service
  services.mullvad-vpn.enable = true;

  # Syncthing option/service
    services = {
        syncthing = {
	    enable = true;
	    user = "agua";
	    dataDir = "/home/agua/Documents";
	    configDir = "/home/agua/Documents/.config/syncthing";
	    overrideDevices = true;
	    overrideFolders = true;
	    devices = {
	        "fairphone" = { id = "HAJMXNK-RMI6GLJ-ZDYCK6S-SMGCDTU-3EU55A3-OVD6LTY-NTQIG7I-RO3VTQL"; };
	    };
	#    folders = {
	#        "Synced Notes" = {
	#	    path = "/home/agua/Documents/2 AREAS DE RESPONSABILIDAD/Equipos TICs/Synced Notes";
	#	    devices = [ "fairphone" ];
	#	};
	#	"Synced Passwords and PGP" = {
	#	    path = "/home/agua/Documents/2 AREAS DE RESPONSABILIDAD/Equipo TICs/Synced Passwords and PGP";
	#	    devices = [ "fairphone" ];
	#	};
	#    };
	};
    };

  # Transmission attempt
    services = {
        transmission = {
	    enable = true;
	    # package = pkgs.transmission;
	    user = "transmission";
	    group = "transmission";
	    openFirewall = true;
	    openRPCPort = true;
	};
    };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
