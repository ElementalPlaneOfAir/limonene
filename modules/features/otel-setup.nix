{ ... }: {
  flake.modules.nixos.otelSetup = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      opentelemetry-collector
    ];
  };
}
