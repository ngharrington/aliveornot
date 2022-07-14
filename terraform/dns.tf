variable "domain" {
    type = string
    default = "aliveornot.net"
}

resource "digitalocean_domain" "default" {
  name = var.domain
}

# Add an A record to the domain for www.example.com.
resource "digitalocean_record" "root" {
  domain = digitalocean_domain.default.id
  type   = "A"
  name   = "@"
  value  = digitalocean_floating_ip.aliveornot-floating-ip.ip_address
}

# resource "digitalocean_record" "www" {
#   domain = digitalocean_domain.default.id
#   type   = "A"
#   name   = "www"
#   value  = digitalocean_floating_ip.aliveornot-floating-ip.ip_address
# }
