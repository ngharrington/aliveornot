# Floating IP assigned to a single IP

data "digitalocean_ssh_key" "neal" {
  name = "neal-xps"
}

resource "digitalocean_floating_ip" "aliveornot-floating-ip" {
  region = "nyc3"
}

resource "digitalocean_droplet" "aliveornot-01" {
  image  = "ubuntu-20-04-x64"
  name   = "aliveornot-01"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.neal.id
  ]
}

resource "digitalocean_floating_ip_assignment" "foobar" {
  ip_address = digitalocean_floating_ip.aliveornot-floating-ip.ip_address
  droplet_id = digitalocean_droplet.aliveornot-01.id
}
