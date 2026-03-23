{
  config,
  pkgs,
  ...
}: {
  # Decrypt the API key to a runtime file at login (0400, never in the environment).
  # The encrypted source lives at secrets/secrets.yaml in this repo.
  # See secrets/README.md for how to create/update the encrypted file.
  sops.secrets.anthropic_api_key = {
    sopsFile = ../../secrets/secrets.yaml;
  };

  programs.opencode = {
    enable = true;

    settings = {
      autoupdate = false;
      autoshare = false;
      model = "anthropic/claude-sonnet-4-6";

      # Reference the decrypted key file directly — never touches the shell environment.
      provider = {
        anthropic = {
          options = {
            apiKey = "{file:${config.sops.secrets.anthropic_api_key.path}}";
          };
        };
      };
    };
  };
}
