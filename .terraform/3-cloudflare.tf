resource "cloudflare_record" "dns_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.project_name
  content   = "d2ffztt838w4th.cloudfront.net"
  type    = "CNAME"
  ttl     = 1
  proxied = false
  allow_overwrite = true
}