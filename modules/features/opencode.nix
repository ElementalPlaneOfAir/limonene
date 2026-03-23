{ inputs, ... }: {
  flake.modules.homeManager.opencode = { config, ... }: {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];

    # Point sops-nix at the default age key location
    sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    # Decrypt the API key to a runtime file at login (0400, never in the environment).
    # The encrypted source lives at secrets/secrets.yaml in this repo.
    sops.secrets.openrouter_api_key = {
      sopsFile = ../../secrets/secrets.yaml;
    };

    programs.opencode = {
      enable = true;

      settings = {
        autoupdate = false;
        autoshare = false;
        model = "openrouter/anthropic/claude-sonnet-4-6";

        provider = {
          openrouter = {
            options = {
              apiKey = "{file:${config.sops.secrets.openrouter_api_key.path}}";
            };
          };
        };
      };
    };
  };
}
