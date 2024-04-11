{ config, pkgs, ... }:

{
nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
# intel
#boot.kernelParams = [ "intel_pstate=disable" "i8042.reset" ];
# amd

boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8812au
];
boot.initrd.kernelModules = [ "8812au" ];

services.xserver.videoDrivers = [ "amdgpu" ];  
hardware.cpu.amd.updateMicrocode = true;                                                                                                                                                                         
hardware.enableRedistributableFirmware = true;                                                                                                                                                                   
hardware.opengl.enable = true;                                                                                                                                                                                   
hardware.opengl.driSupport = true;

  imports =
    [ 
      ./hardware-configuration.nix
    ];

# boot.kernel.sysctl."kernel.sysrq" = 1;
  powerManagement.cpuFreqGovernor = "ondemand";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "cn";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # shell system-wide
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.f = {
    isNormalUser = true;
    description = "f";
    extraGroups = [ "networkmanager" "wheel" "docker"];
  };

  # sudo no password
  security.sudo.wheelNeedsPassword = false;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "f";

  # Allow unfree packages
  hardware.bluetooth.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =  [ pkgs.firefox pkgs.vim pkgs.git pkgs.gcc-unwrapped pkgs.gnumake pkgs.neofetch pkgs.neovim pkgs.xkeysnail pkgs.volumeicon pkgs.hugo pkgs.emacs pkgs.nodejs pkgs.xsel pkgs.smartmontools pkgs.wqy_microhei pkgs.python3 pkgs.rime-data pkgs.adwaita-qt pkgs.redshift pkgs.python3.pkgs.pip pkgs.screen pkgs.python3.pkgs.pymysql pkgs.iotop pkgs.blender pkgs.iotop pkgs.blueberry pkgs.gimp pkgs.flameshot pkgs.you-get pkgs.shotcut pkgs.obs-studio pkgs.cpu-x pkgs.lm_sensors pkgs.s-tui pkgs.glmark2 ];

  # zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch";
    };
  };
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" "wd" "z" "zsh-autosuggestions" "zsh-syntax-highlighting"];
    theme = "agnoster";
  };
  programs.zsh.ohMyZsh.custom = "/home/f/custom";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # docker enable
  virtualisation.docker.enable = true;
  # boot timeout
  boot.loader.timeout = 1;

  # fcitx5
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-configtool
        fcitx5-rime
        rime-data
    ];
  };
  # mysql
  services.mysql.package = pkgs.mariadb;
  services.mysql.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
