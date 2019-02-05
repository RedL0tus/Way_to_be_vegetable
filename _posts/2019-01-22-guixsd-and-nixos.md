---
title: （重新）体验了一下 GuixSD 和 NixOS
layout: post
date: 2019-01-22 21:42:00 -0800
---

很久之前就听说 FSF 的老贼们整了一个新包管理和发行版叫 guix 和 GuixSD，当时看介绍说 guix 是个 “Transactional Package Manager”，之后没有仔细去了解过。前两天突然看到有人发了个文章安利 GuixSD，看了一下发现这玩意儿怎么跟之前体验过一下的 NixOS 那么像？查了一下才知道这好像就是个 nix （NixOS 的包管理）的 fork 来着。感觉 FSF 的老贼们真的是什么发行版火了就照着做一个全自由软件的 GNU/Linux-libre 发行版。不过这次 guix 相比 nix 还是有不少改动的（不像别的就只是重新打了个包），配置文件使用的语言从 nix 自创的 nix 换成了 Guile Scheme，init 系统从 systemd 换成了 Shepherd（我前几天才听说有这么个东西，本来是给 Hurd 用的） ，成功地让我起了兴趣（虽然我的兴趣不值钱）。

安装过程什么的我就不多说了，两边都有文档，个人感觉 NixOS 的文档更详细一点但是也更乱。后面会带上我用的配置。

这两个发行版做的就是让一个包管理根据一套配置管理整个系统（包括软件本身和各种配置）；同时把所有软件都放到一个目录下集中管理（guix 下是 /gnu，NixOS 下是 /nix），然后在根据一定设置创建 symlink 到另一个目录下模拟出一个环境叫 profile 使用。优点是你想让多少个不同版本的同一个软件共存就能放几个，还有回滚系统等等的能力。大概可以理解为做一个高级版的 snapd 或 flatpak 或 docker，然后用它来管理整个系统。具体可以去看他们的介绍，比如 [Nix Pills](https://nixos.org/nixos/nix-pills/)，我语文不好就不多说了。

反正体验就是，装完了之后，什么 /nix 或 /gnu 之外，几乎什么都没有，/run 下面成吨成吨的 symlink。

（哦对了，guix 和 nix 都可以在别的发行版上运行，nix 甚至能用来拯救 macOS，不一定要装他们的发行版也能体验到一部分功能。）

听起来很美好，但是这跟现有 Linux 发行版区别还是很大，两个发行版本身人手也不算多，就导致会有一些问题，就比如：

共同的坑：
 - **完全**不遵守 LSB，别人发行的二进制除非 patchelf 不然都不能运行。
 - 总体来说资料还是少，虽然 NixOS 已经是一个从 2003 年开始就有的老项目了，文档还是不算多；至于 guix... 包管理相关的东西倒是都有文档，但是缺乏新手指引和示例导致很多部分很难看懂（比如设置默认 shell 的语法，文档里说是用一个 G-Expression，但是并没有写明具体的使用方法，G-Expression 的文档页面也没说使用方法），部分常见问题倒是能在邮件列表里找到，总体来说还是少。
 - 可能是因为对软件的魔改还不够彻底，有的时候还是会遇到点小问题。
 - 可能因为中文用户较少，这两个发行版的默认中文字体渲染都很烂。

GuixSD：

**（GuixSD 还是新发行版，以后可能还会有改动，下面所有的都是基于 0.16 版来说）**
 - 它是一个 GNU/Linux-libre 的全自由软件的发行版，这意味着它在非常清蒸的同时也丢掉了对很多硬件/程序的支持（除非自行打包内核和那些对应的软件）。只是我手头正好有一台换了 ath9k 网卡的 ThinkPad X220 才可以无痛使用，不然无线网卡驱动、显卡驱动等等可能都会有问题。同时那群维护者在自由软件上也是激进过头了，[之前](https://gnunet.org/bot/log/guix/2016-05-16)有人在 IRC 上问能不能打包 Telegram Desktop（GPLv3），可能是维护者的几个人在讨论之后说“这 IM 服务端不自由还是用 IRC 或电邮吧”就不了了之了，到现在都没打包。
 - 我照着官方文档配了 LUKS 结果不能启动，最后还是用了普通 ext4。说起来挺搞笑的... 它把内核什么的全放在 LUKS 加密过的分区里，GRUB 上也不做别的配置，能启动才怪了...
 - 有部分包上游没有进行构建，这时候 guix 会自动下载工具链进行编译安装（比如 IceCat，自由版本的 Firefox，我 X220 上编译花了几个小时），这就意味着在老机器上安装包可能会比较痛苦。
 - 还是之前说的文档问题，我花了挺多时间都没找到让它根据 file system label 来启用 SWAP 分区的方法，而这样的问题还有不少。
 - 工具链版本有点奇妙，我看它安装的时候 GCC 5 6 7 8 都下载了一遍，直接安装 GCC 竟然装的是 GCC 5.5.0，9102 年了还 5.5.0... 太丢人了（还亏它是 FSF 亲儿子呢）。
 - IME 支持很烂，fcitx 只打了 fcitx 本体和 fcitx-configtool；RIME 之类的输入法引擎全归类到 iBus 模块下面了，我在 IRC 频道里问了相关事情就直接被忽略了；iBus 装上之后除 GNOME 外都没办法让它自动启动，传统发行版上 .xprofile 里加变量的方式完全没用，文档里也没有提到任何相关的东西；~~RIME 可能是坏的，无法启动。~~  
  后来有个大佬在 Telegram 里联系了我，说 RIME 实际是可以用的，但是需要[额外的设置](https://github.com/guix-china/help)，还是没有 NixOS 用的方法完善。可能需要有知道怎么做才好的人去把它做成一个 module（就像 NixOS 那样）。但我应该不会是那个人，原因见下。  
 - MATE 下的锁屏是坏的（什么都不做就说 Authentication Failed），xfce 下无法启动输入法，就只有 GNOME 可能还能用。
 - fontconfig 只会读用户 profile 下的字体。
 - Shepherd 还是太冷门惹... 启动速度也比 systemd 慢~~（不过至少比 BSD init 快）~~。

我没去报 bug 的原因是：一，我懒，我去问问题都没人理我，我干嘛要帮他们（虽然我也帮不大上）；二，他们的 Bug tracker 太硬核叻... 只有邮件列表，Bug report 和提交 patch 都在一起的，我不敢说话 🤦‍♀️

NixOS：
 - 默认的包有点老了... 内核默认还在用 4.14... Stable 最新 4.19， Unstable 已经打了 4.20，需要手动指定才能用新的。
 - 听说 Nixpkgs Unstable 的包数量都快超过 AUR 了（老早超过 Debiantai 了），但是实际用的时候还是比 AUR 少了一些东西。
 - IME 基本能用，但是我实在不知道打了 fcitx-rime 不打 ibus-rime 是什么操作... 要不过两天我打个试试？
 - 因为是自动检查更新并打包的，所以有时候会打了 Unstable 的软件，比如说这次 MATE 就打了个 1.21... 然后一些主题炸了。我找到了一个相关的降级回 1.20 的 PR，我稍微催了一下马上就给合并了，并且禁止了 bot 自动查找 MATE 的新版本（可能他们的 bot 还不支持根据一定规则跳过部分版本？），给我感觉还是挺好的 XD

总的来说感觉 NixOS 的可用性比 GuixSD 高出一大截。另外虽然我想说我更喜欢 Scheme 而不是这个 nix... 但是感觉有的时候还是 nix 的可读性更好一点。

其实我感觉他们既然都已经有那么多吨 symlink 了，为什么不干脆遵守一下 LSB 呢，无非就是再多几吨 symlink... 这样碎片化越来越严重对整个社区都没什么好处啊。  
多版本共存？实际使用场景并不多。其实这方面感觉真的很像 flatpak 或 snap...  
Reproducible build？ 这应该是大多数发行版的打包系统的标配吧，只是他们把这暴露给了普通用户。  
至于资料的话它们毕竟还算是比较冷门的... 还算能原谅。

至于说这是 Linux 发行版的未来吗？我不知道啊。这确实看上去很有趣，但是实际使用上并没有那么美好，同时感觉也缺少能竞争过传统发行版的地方。

---

我 GuixSD 的配置其实跟官方示例比没多大变化... 因为不知道怎么改：

```scheme
;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce where the
;; root partition is encrypted with LUKS.

(use-modules (gnu) (gnu system nss))
(use-service-modules desktop ssh)
(use-package-modules certs 
                     xorg mate fonts fontutils gnome freedesktop xdisorg
                     ssh shells ncurses file
                     gnuzilla curl wget rsync
                     gcc ibus
                     version-control)

(operating-system
  (host-name "x220")
  (timezone "America/Los_Angeles")
  (locale "en_US.utf8")

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (target "/boot/efi")))

  (kernel-arguments '("thinkpad_acpi.fan_control=1"))

  ;; Specify a mapped device for the encrypted root partition.
  ;; The UUID is that returned by 'cryptsetup luksUUID'.
  ;;
  ;; (mapped-devices
  ;;  (list (mapped-device
  ;;         (source (uuid "5786a4c6-9a95-4b4d-97e5-8ae7c5a99f44"))
  ;;         (target "root")
  ;;         (type luks-device-mapping))))

  (file-systems (cons* (file-system
                         (device (file-system-label "GUIX"))
                         (mount-point "/")
                         (type "ext4"))
                         ;; (dependencies mapped-devices))
                       (file-system
                         (device (file-system-label "EFI"))
                         (mount-point "/boot/efi")
                         (type "vfat"))
                       %base-file-systems))

  (swap-devices '("/dev/sda3"))

  (users (cons (user-account
                (name "kay")
                (comment "Kay")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video"))
                (home-directory "/home/kay")
                (shell #~(string-append #$zsh "/bin/zsh")))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (cons* nss-certs         ;for HTTPS access
                   ;; gvfs              ;for user mounts
                   openssh
                   zsh
                   icecat
                   curl wget rsync
                   git
                   fontconfig xdg-user-dirs
                   ;; mate-screensaver
                   ncurses gcc binutils file
                   arc-theme
                   network-manager-applet
                   ibus ibus-rime librime rime-data
                   %base-packages))

  ;; Add GNOME and/or Xfce---we can choose at the log-in
  ;; screen with F1.  Use the "desktop" services, which
  ;; include the X11 log-in service, networking with
  ;; NetworkManager, and more.
  (services (cons* (mate-desktop-service)
                   (gnome-desktop-service)
                   (xfce-desktop-service)
                   ;; (plasma-desktop-service) ;; Not there yet
                   (service openssh-service-type
                     (openssh-configuration
                       (x11-forwarding? #t)))
                   %desktop-services))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
```

然后是我的 NixOS 配置，这个我还是花了一些时间改的，参考了别人的几个配置：
（这个在使用的时候要注意，需要先添加 [nixos-hardware](https://github.com/NixOS/nixos-hardware) 这个 channel，然后改成你的机型）

```nix
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
```

我就放在 [https://v2bv.net/configuration.nix](https://v2bv.net/configuration.nix) 好叻！

---

说起来还有个 Fedora SilverBlue 看起来也挺有意思，什么时候去试试看（