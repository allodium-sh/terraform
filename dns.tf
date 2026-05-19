data "cloudflare_zone" "main" {
  filter = {
    account_id = var.cloudflare_account_id
    name       = var.domain
  }
}

resource "cloudflare_dns_record" "headscale" {
  zone_id = data.cloudflare_zone.main.zone_id
  name = "headscale"
  content = "136.118.241.125"
  type = "A"
  proxied = false
  ttl = 3600
}

# Add DNS records below. Example:
# resource "cloudflare_dns_record" "example" {
#   zone_id = data.cloudflare_zone.main.zone_id
#   name    = "www"
#   content = "192.0.2.1"
#   type    = "A"
#   proxied = true
# }
