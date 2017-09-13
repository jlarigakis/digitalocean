variable "do_token" {}
variable "domain_name" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "app" {
  image  = "ubuntu-16-04-x64"
  name   = "app.thessaly.ca"
  region = "sfo2"
  size   = "1Gb"
  resize_disk = false
  ssh_keys = ["${digitalocean_ssh_key.default.id}"]
}

resource "digitalocean_floating_ip" "app" {
  droplet_id = "${digitalocean_droplet.app.id}"
  region = "sfo2"
}

resource "digitalocean_domain" "app" {
  name = "${var.domain_name}"
  ip_address   = "${digitalocean_floating_ip.app.ip_address}"
}

resource "digitalocean_ssh_key" "default" {
  name = "Jason Personal Macbook"
  public_key = "${file("/Users/jason/.ssh/id_ecdsa.pub")}"
}
