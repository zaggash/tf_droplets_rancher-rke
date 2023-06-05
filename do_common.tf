resource "digitalocean_vpc" "infra-clusters" {
  name        = "${var.prefix}-infra-clusters"
  region      = var.region_server
}

resource "tls_private_key" "genkey" {
  algorithm   = "ED25519"
}

resource "local_file" "id_ed25519" {
    content         = tls_private_key.genkey.private_key_openssh
    filename        = "id_ed25519"
    file_permission = "0400"
}

resource "local_file" "id_ed25519_pub" {
    content         = tls_private_key.genkey.public_key_openssh
    filename        = "id_ed25519.pub"
    file_permission = "0400"
}

resource "digitalocean_ssh_key" "nodes" {
  name       = "${var.prefix}-nodes-key"
  public_key = tls_private_key.genkey.public_key_openssh
}

locals {
  ssh_private_key         = tls_private_key.genkey.private_key_openssh
  ssh_public_fingerprint  = digitalocean_ssh_key.nodes.fingerprint
}
