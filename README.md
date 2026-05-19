# Allodium Infrastructure

OpenTofu configuration for managing Allodium infrastructure. Currently manages DNS for `allodium.sh` via Cloudflare, with state stored in Cloudflare R2.

## Repository Structure

```
.
├── backend.tf       # Cloudflare R2 state backend configuration
├── providers.tf     # Provider declarations (Cloudflare)
├── versions.tf      # Required providers and OpenTofu version constraints
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── dns.tf           # Cloudflare DNS zone and records
├── flake.nix        # Nix flake providing the development environment
├── .envrc           # direnv integration for the Nix flake
└── .github/
    └── workflows/
        ├── plan.yml   # Runs tofu plan on PRs and comments the result
        └── apply.yml  # Runs tofu apply on merge to main
```

New infrastructure concerns (e.g., cloud servers, GitHub repos) should be added as additional `.tf` files at the root.

## Prerequisites

- [Nix](https://nixos.org/download/) with flakes enabled
- [direnv](https://direnv.net/) (optional, for automatic shell activation)

## Development Environment

The Nix flake provides all required tooling (OpenTofu, terraform-ls, tflint, terraform-docs). This same environment is used in CI.

With direnv:

```sh
cd terraform
direnv allow
```

Without direnv:

```sh
cd terraform
nix develop
```

## Local Development

To test changes locally, you need your own Cloudflare account with a domain registered (any domain works). The production `allodium.sh` domain is only accessible via CI.

### 1. Set Up a Local Backend

Create a `local.tfbackend` file (gitignored) to use local state instead of the production R2 bucket:

```sh
tofu init -backend=false
```

Or use your own R2 bucket by creating a backend config file and passing it to init.

### 2. Set Environment Variables

| Variable | Purpose |
|----------|---------|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token for your account |
| `TF_VAR_cloudflare_account_id` | Your Cloudflare account ID |

### 3. Override the Domain

Pass your test domain when running plan/apply:

```sh
tofu plan -var="domain=yourdomain.com"
tofu apply -var="domain=yourdomain.com"
```

Or create a `terraform.tfvars` file (gitignored):

```hcl
domain = "yourdomain.com"
```

## CI/CD

Production changes to `allodium.sh` are managed entirely through GitHub Actions:

1. **Open a PR** -- the `plan` workflow runs `tofu plan` and posts the output as a PR comment
2. **Push updates** -- the previous plan comment is deleted and a new one is posted with the latest plan
3. **Merge to main** -- the `apply` workflow runs `tofu apply -auto-approve`

Concurrent applies are queued, not cancelled, to prevent partial state issues.

### GitHub Secrets

The following secrets must be configured in the repository:

- `CLOUDFLARE_API_TOKEN`
- `AWS_ACCESS_KEY_ID` (R2 access key for state backend)
- `AWS_SECRET_ACCESS_KEY` (R2 secret key for state backend)
- `TF_VAR_CLOUDFLARE_ACCOUNT_ID`
