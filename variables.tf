variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "domain" {
  description = "Primary domain to manage"
  type        = string
  default     = "allodium.sh"
}
