# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/x220>
      ./hardware-configuration.nix
    ];

  # Hardware configuration
  sound.enable = true;
  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
    trackpoint.emulateWheel = true;
    pulseaudio.enable = true;
    bluetooth.enable = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  # Use the GRUB EFI boot loader.
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      systemd-boot.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_4_20;
    kernelParams = [
      "thinkpad_acpi.fan_control=1"
      "acpi_osi=\"!Windows 2012\""
      "acpi_osi=Linux"
      "acpi=force"
    ];
    initrd.kernelModules = [ "acpi" "thinkpad-acpi" "acpi-call" ];
    supportedFilesystems = [ "nfs" "ntfs" "exfat" ];
  };

  networking.hostName = "x220"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "4.2.2.1" " 4.2.2.2" "9.9.9.9" "8.8.8.8" "8.8.4.4" ];
  networking.networkmanager = {
    enable = true;
    dns = "none";
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ libpinyin mozc ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget vim nano sudo tmux curl zsh networkmanagerapplet firefox
    unzip spotify w3m ntfs3g gptfdisk gcc autoconf bluez gnumake
    xclip ffmpeg cryptsetup pavucontrol automake unrar p7zip
    tdesktop git tilix file htop gtk-engine-murrine arc-theme
    gnome-themes-extra gnome-themes-standard papirus-icon-theme
    wireguard scrot neofetch restic ibus-qt
  ];

  nixpkgs.config = {
    android_sdk.accept_license = true;
    allowUnfree = true;
  };

  # powerManagement.cpuFreqGovernor = pkgs.lib.mkForce null;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    light.enable = true;
    adb.enable = true;
    java.enable = true;
    gnupg.agent = {
      enable = true; 
      enableSSHSupport = true;
    };
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "python" "man" ];
        theme = "robbyrussell";
      };
    };
  };

  # List services that you want to enable:

  # Power related
  services.tlp.enable = true;
  services.thermald.enable = true;

  # Redshift
  services.redshift = {
    enable = true;
    latitude = "36.7";
    longitude = "119.8";
    temperature.day = 5700;
    temperature.night = 3500;
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    forwardX11 = true;
    allowSFTP = true;
    permitRootLogin = "no";
    openFirewall = true;
    passwordAuthentication = false;
    challengeResponseAuthentication = false;
  };

  # Firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "terminate:ctrl_alt_bksp";
    videoDrivers = [ "modesetting" ];
    displayManager.lightdm.enable = true;
    desktopManager.mate.enable = true;
    libinput = {
      enable = true;
      disableWhileTyping = true;
      tapping = true;
    };
  };

  # Enable flatpak
  services.flatpak = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kay = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/kay";
    description = "Kay";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "audio" "video" "disk" "cdrom" "users" "systemd-journal" "lp" "networkmanager" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWeay/xBNMhnBy3GJcGkQNNa44gRBqXYa+F4RW6VW1E kay@bazinga" ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
