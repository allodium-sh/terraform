# State is stored in Cloudflare R2 using the S3-compatible backend.
#
# Bootstrap steps:
#   1. Create an R2 bucket named "allodium-tfstate" in the Cloudflare dashboard
#   2. Create an R2 API token (Settings > R2 > Manage R2 API Tokens)
#   3. Export the following env vars:
#        AWS_ACCESS_KEY_ID     = <R2 access key>
#        AWS_SECRET_ACCESS_KEY = <R2 secret key>
#   4. Run: tofu init

terraform {
  backend "s3" {
    bucket = "allodium-tfstate"
    key    = "terraform.tfstate"
    region = "auto"

    endpoints = {
      s3 = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
    }

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}
