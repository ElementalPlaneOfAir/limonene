{ inputs, ... }: {
  flake.modules.homeManager.opencode = { config, ... }: {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];

    sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    sops.secrets.openrouter_api_key = {
      sopsFile = ../../secrets/secrets.yaml;
    };

    # Render auth.json with the decrypted key substituted in by sops-nix.
    # opencode reads provider credentials from this file, not from config.json.
    sops.templates."opencode-auth" = {
      content = ''{"openrouter":{"type":"api","key":"${config.sops.placeholder.openrouter_api_key}"}}'';
      path = "${config.home.homeDirectory}/.local/share/opencode/auth.json";
      mode = "0600";
    };

    programs.opencode = {
      enable = true;
      settings = {
        autoupdate = false;
        autoshare = false;
        model = "openrouter/anthropic/claude-sonnet-4-6";
      };
    };
  };
}
