# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
let
  # config , nixpkgs version name ang git commit reference 
  gitRepo      = "${toString pkgs.path}/../.git";
  gitCommitId  = lib.substring 0 0 (lib.commitIdFromGitRepo gitRepo);
  
  # fonts
# for derivation and attrsets
  my-python-packages = ps: with ps; [
  pip
  fonttools
  setuptools
  afdko
  ];

  # ## my gpg  is 7BFCC587A8F5985B4658933538BABABCEF0A2C0A for whenever i encrupyt something here. LUKS or otherwise.
in 
{
  system.nixos.versionSuffix = "-7BFCC587A8F5985B4658933538BABABCEF0A2C0A-${gitCommitId}";
  system.nixos.label = "7BFCC587A8F5985B4658933538BABABCEF0A2C0A-${gitCommitId}";
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };
  nix = {
  package = pkgs.nixFlakes;
  extraOptions = ''
    experimental-features = nix-command flakes
    trusted-users = [ "root" "x" ];
  '';
};
  nix.nixPath = [
  "nixpkgs=/etc/nixos/nixpkgs"
  "nixos-config=/etc/nixos/configuration.nix"
  ];
  nixpkgs.overlays = [
        (self: super: rec {
      nyxt = super.nyxt.overrideAttrs (old: {
        version = "3-pre-release-2";
        installPhase = ''
gappsWrapperArgs+=(
        --set WEBKIT_FORCE_SANDBOX 0
                )
'' + old.installPhase;
      });
      lispPackages = super.lispPackages // {
        nyxt = super.lispPackages.nyxt.overrideAttrs (old: rec {
          version = "3-pre-release-2";
          patches = [];
          src = super.fetchFromGitHub {
            owner = "atlas-engineer";
            repo = "nyxt";
            rev = "${version}";
            sha256 = "0ancmbqpkzlnwp4g2f7gfwdpcb3mk8wsfrwsm87i168h8kn6bnj4";
          };
        });
      };
    })
  ];

 

  # nix = {
  #   extraOptions = ''
  #   trusted-users = [ "root" "x" ];
  #     '';
  # };
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the LXQT Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.lxqt.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  users.users.x = {
    isNormalUser = true;
    description = "x";
    extraGroups = [ "networkmanager" "wheel" "tss" ];
    packages = with pkgs; [
      
      #firefox
    #  thunderbird
       
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  security.tpm2.enable = true;
security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
#users.users.x.extraGroups = [ "tss" ];  # tss group has access to TPM devices

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
   agda
   (agda.withPackages (with agdaPackages; [ standard-library ]))
   idris
   (idrisPackages.with-packages (with idrisPackages; [ contrib pruviloj ]))
   python310
   (pkgs.python3.withPackages my-python-packages)
   (import (fetchTarball https://github.com/cachix/devenv/archive/v0.6.2.tar.gz)).default
   emacs
   ((emacsPackagesFor emacs).emacsWithPackages (epkgs:
     [ epkgs.dash epkgs.agda2-mode ]))
    nyxt
    gnutls
    gnumake
    autoconf
    sbcl
   tpm2-tools
   tpm2-tss
   grub-tb-efi
    #gnupg
    #pinentry
    openssl_3
    git
    #libnma-gtk4
    #sqlite
    #mob
    #pantalaimon
    #maestral
    direnv
    nyxt
    cachix
    ispell
    busybox
    
];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
