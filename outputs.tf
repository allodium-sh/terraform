output "zone_id" {
  description = "Cloudflare zone ID for the primary domain"
  value       = data.cloudflare_zone.main.zone_id
}

output "nameservers" {
  description = "Cloudflare nameservers assigned to the zone"
  value       = data.cloudflare_zone.main.name_servers
}
