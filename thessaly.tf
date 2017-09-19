variable "do_token" {}
variable "domain_name" {}
variable "ssh_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "image" {
  default = "ubuntu-17-04-x64"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

terraform {
  backend "gcs" {
    bucket  = "thessaly"
    path    = "terraform/terraform.tfstate"
  }
}

resource "digitalocean_floating_ip" "app" {
  region = "sfo2"
}

resource "digitalocean_domain" "app" {
  name = "${var.domain_name}"
  ip_address   = "${digitalocean_floating_ip.app.ip_address}"
}

resource "digitalocean_ssh_key" "default" {
  name = "Jason Personal Macbook"
  public_key = "${file("${var.ssh_key_path}")}"
}
