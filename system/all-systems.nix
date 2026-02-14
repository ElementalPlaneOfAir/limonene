# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  nicole_ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINBfMZjr6H4oK3qSBTxjZrMZptWXdzYC6QV4bdS892Ls nicole@vermissian"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1tyFv2UbkAJMx2U6bp8OwRx5wMpK7/DxSslcPS0sWY nicole@incarnadine"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDBQresTdgx3Se26QxvwD/S9SaCRCWL8dvZwZ6IM62b2 nicole@cheddar"
  ];
  brad_ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaOgK4fO5gTB79Infge2b+31VzXnC23lqV7m5NA+xuz bvenner@proton.me"
  ];
in {
  # Copy flake configuration to /etc/nixos/limonene
  environment.etc."nixos/limonene".source = ../.;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot.binfmt.registrations."aarch64-linux".fixBinary = true;
  users.users.nicole = {
    openssh.authorizedKeys.keys = nicole_ssh_keys;
  };
  services.throttled.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  environment.shellAliases = {
    nrs = ''sudo nixos-rebuild switch --flake /home/nicole/limonene'';
    nrb = ''nixos-rebuild build --verbose --flake /home/nicole/limonene'';
  };
  # Desktop services disabled for headless systems
  services.atd.enable = true;
  environment.systemPackages = with pkgs; [
    fwupd
    stress
    phoronix-test-suite
    lutris

    yggdrasil
    python314
    postgresql_17
    nix-ld
    wineWowPackages.waylandFull
    # lutris
    heroic
    feather
    devenv
    gnome-disk-utility
    git
    # system packages
    gcc
    openssl_3
    # Write to cpu registers:
    msr-tools
    # This belongs in the root systems for all packages
    parted
  ];
  # Software for bios updates.
  services.fwupd.enable = true;
  programs.nix-ld.enable = true;
  programs.light.enable = true;

  # Disable wakeup for internal laptop keyboard (serio0)
  # Prevents accidental wake from suspend when external keyboard rests on laptop
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="serio", KERNEL=="serio0", ATTR{power/wakeup}="disabled"
  '';

  virtualisation.docker = {
    enable = true;
  };
  services.tailscale = {
    enable = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable= true;
  hardware.enableAllFirmware = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Allow non-root processes to bind to privileged ports (80, 443)
  # Required for local development with Caddy HTTPS
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [80 443 8080 8443]; # don’t globally allow ssh
    extraCommands = ''
      # Allow RFC1918 IPv4 ranges
      iptables -A INPUT -p tcp --dport 22 -s 192.168.0.0/16 -j ACCEPT
      iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT
      iptables -A INPUT -p tcp --dport 22 -s 172.16.0.0/12 -j ACCEPT

      # Block all other SSH attempts
      iptables -A INPUT -p tcp --dport 22 -j DROP
    '';
  };

  # Set your time zone.
  time.timeZone = "America/Denver";
  services.gnome.gnome-keyring.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.fish.enable = true;
  users.users.nicole = {
    isNormalUser = true;
    description = "Nicole";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      #  thunderbird
    ];
    shell = pkgs.fish;
  };

  users.users.brad = {
    isNormalUser = true;
    description = "Brad";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = brad_ssh_keys;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.trusted-users = ["root" "nicole" "brad"];
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };
}
