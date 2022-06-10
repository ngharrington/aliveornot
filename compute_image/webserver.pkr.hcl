packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/digitalocean"
    }
  }
}

variable "api_token" {
  type = string
  default = ""
}

variable "ssh_private_key_file" {
  type = string
  default = ""
}


source "digitalocean" "webserver" {
  api_token     = var.api_token
  image         = "ubuntu-20-04-x64"
  region        = "nyc3"
  size          = "s-1vcpu-1gb"
  ssh_username  = "root"
  snapshot_name = "aliveornot-{{timestamp}}"
  droplet_name  = "packer-webserver"
  ssh_key_id    = "34686971"
  ssh_private_key_file = var.ssh_private_key_file
}

build {
    sources = [
        "source.digitalocean.webserver"
    ]
 
    provisioner "ansible" {
      playbook_file = "./playbook.yml"
    }
}