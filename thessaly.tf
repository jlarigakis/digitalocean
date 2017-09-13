variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "app" {
  image  = "ubuntu-17-04-x64"
  name   = "app.thessaly.ca"
  region = "sfo2"
  size   = "1Gb"
  resize_disk = false
}

resource "digitalocean_floating_ip" "app" {
  droplet_id = "${digitalocean_droplet.app.id}"
  region = "sfo2"
}

resource "digitalocean_domain" "app" {
  name = "app.thessaly.ca"
  ip_address   = "${digitalocean_floating_ip.app.ip_address}"
}
