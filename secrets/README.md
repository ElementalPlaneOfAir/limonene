# Secrets

Secrets in this directory are encrypted with [sops](https://github.com/getsops/sops) using your age key.

## Initial setup

1. **Generate an age key** (if you don't have one):
   ```sh
   age-keygen -o ~/.config/sops/age/keys.txt
   ```
   Note the public key printed to stdout — you'll need it below.

2. **Create `.sops.yaml`** at the repo root with your public key:
   ```yaml
   keys:
     - &nicole age1yourpublickeyhere
   creation_rules:
     - path_regex: secrets/.*\.yaml$
       key_groups:
         - age:
           - *nicole
   ```

3. **Create and encrypt `secrets.yaml`**:
   ```sh
   sops secrets/secrets.yaml
   ```
   Add your secrets in the editor that opens:
   ```yaml
   anthropic_api_key: sk-ant-...
   ```
   Save and close — sops encrypts it automatically.

## Adding or updating a secret

```sh
sops secrets/secrets.yaml
```

## What gets decrypted and where

sops-nix decrypts secrets at login into `$XDG_RUNTIME_DIR/secrets.d/` (mode 0400, your user only).
opencode reads the key via `{file:...}` in its config — the key never enters the shell environment.
