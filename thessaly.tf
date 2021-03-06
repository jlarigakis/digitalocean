variable "domain_name" {}

variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "image" {
  default = "ubuntu-17-10-x64"
}

provider "digitalocean" {}

terraform {
  backend "gcs" {
    bucket = "thessaly"
    path   = "terraform/digitalocean.tfstate"
  }
}

resource "digitalocean_droplet" "app" {
  image       = "${var.image}"
  region      = "sfo2"
  name        = "${var.domain_name}"
  size        = "s-2vcpu-4gb"
  resize_disk = false
  ssh_keys    = ["${digitalocean_ssh_key.default.id}"]
}

resource "digitalocean_floating_ip" "app" {
  droplet_id = "${digitalocean_droplet.app.id}"
  region     = "sfo2"
}

resource "digitalocean_domain" "app" {
  name       = "${var.domain_name}"
  ip_address = "${digitalocean_floating_ip.app.ip_address}"
}

resource "digitalocean_ssh_key" "default" {
  name       = "Jason Personal Macbook"
  public_key = "${file("${var.ssh_key_path}")}"
}

output "ip" {
  value = "${digitalocean_floating_ip.app.ip_address}"
}
