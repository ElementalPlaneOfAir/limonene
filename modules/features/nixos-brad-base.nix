{ ... }: {
  flake.modules.nixos.bradBase = { config, pkgs, ... }: let
    brad_ssh_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHaOgK4fO5gTB79Infge2b+31VzXnC23lqV7m5NA+xuz bvenner@proton.me"
    ];
    RStudio-with-my-packages = pkgs.rstudioWrapper.override {
      packages = with pkgs.rPackages; [ ggplot2 rix stringr readxl ];
    };
  in {
    users.users.brad = {
      isNormalUser = true;
      description = "Brad";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = brad_ssh_keys;
    };

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    environment.shellAliases = {
      nrs = ''sudo nixos-rebuild switch --flake /home/brad/limonene'';
      nrb = ''nixos-rebuild build --verbose --flake /home/brad/limonene'';
    };

    services.flatpak.enable = true;

    virtualisation.docker.enable = true;
    services.tailscale.enable = true;
    services.fwupd.enable = true;
    services.printing.enable = true;
    services.gnome.gnome-keyring.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      brightnessctl
      fwupd
      stress
      phoronix-test-suite
      gnome-disk-utility
      yggdrasil
      networkmanager
      nettools
      python314
      postgresql_17
      git
      gcc
      openssl_3
      RStudio-with-my-packages
      nix-ld
      devenv
      heroic
      feather
      signal-desktop
      libclang
      pkg-config
      openssl
    ];

    networking.networkmanager.enable = true;
    hardware.enableAllFirmware = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.firewall = {
      enable = false;
      allowedTCPPorts = [ 80 443 8080 8443 ];
      extraCommands = ''
        iptables -A INPUT -p tcp --dport 22 -s 192.168.0.0/16 -j ACCEPT
        iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT
        iptables -A INPUT -p tcp --dport 22 -s 172.16.0.0/12 -j ACCEPT
        iptables -A INPUT -p tcp --dport 22 -j DROP
      '';
    };

    time.timeZone = "America/Denver";
    programs.fish.enable = true;

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [
      "libsoup-2.74.3"
    ];

    nix = {
      settings.trusted-users = [ "root" "brad" ];
      extraOptions = ''
        experimental-features = nix-command flakes
        extra-substituters = https://devenv.cachix.org
        extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
      '';
    };
  };
}
