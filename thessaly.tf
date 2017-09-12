variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "app" {
  image  = "ubuntu-17-04-x64"
  name   = "app.thessaly.ca"
  region = "sfo2"
  size   = "512mb"
}

resource "digitalocean_floating_ip" "app" {
  droplet_id = "${digitalocean_droplet.app.id}"
  region = "sfo2"
}
