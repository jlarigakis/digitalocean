variable "do_token" {}
variable "domain_name" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "app" {
  image  = "ubuntu-17-04-x64"
  name   = "app.thessaly.ca"
  region = "sfo2"
  size   = "1Gb"
  resize_disk = false
  user_data = <<EOF
users:
- name: foobar
  primary-group: jason
  groups: users, admin
  sudo: ALL=(ALL) NOPASSWD:ALL
  lock_passwd: true
  ssh-authorized-keys:
    - ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNxXkRRkpptbICFmghQsvIDPc9kiAUMuPwEgoMBT3+kCMooFm7SsQtkeQqUfy3Wo7zYkQRN5DIW5CxHtwX+m61k
EOF
}

resource "digitalocean_floating_ip" "app" {
  droplet_id = "${digitalocean_droplet.app.id}"
  region = "sfo2"
}

resource "digitalocean_domain" "app" {
  name = "${var.domain_name}"
  ip_address   = "${digitalocean_floating_ip.app.ip_address}"
}
