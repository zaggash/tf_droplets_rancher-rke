resource "digitalocean_droplet" "rke2-all" {
  count       = var.downstream_rke2_enabled ? var.rke2_all_roles_nodes : 0
  image       = var.nodes_image
  name        = "${var.prefix}-rke2-all-${count.index}"
  vpc_uuid    = digitalocean_vpc.infra-clusters.id
  region      = var.region_server
  size        = var.size
  ssh_keys    = [local.ssh_public_fingerprint]
  tags        = [join("",["user:",replace(split("@",data.digitalocean_account.do-account.email)[0],".","-")])]

  user_data = templatefile(
    "files/userdata_register",
    {
      docker_version = var.docker_version
      register_command = module.kubernetes_data.rke2_cluster_command
      node_roles = "--etcd --controlplane --worker"
    })

  provisioner "remote-exec" {
    connection {
      type          = "ssh"
      user          = var.user
      host          = self.ipv4_address
      private_key   = local.ssh_private_key
    }
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
  }
}

resource "digitalocean_droplet" "rke2-etcd" {
  count       = var.downstream_rke2_enabled ? var.rke2_etcd_nodes : 0
  image       = var.nodes_image
  name        = "${var.prefix}-rke2-etcd-${count.index}"
  vpc_uuid    = digitalocean_vpc.infra-clusters.id
  region      = var.region_server
  size        = var.size
  ssh_keys    = [local.ssh_public_fingerprint]
  tags        = [join("",["user:",replace(split("@",data.digitalocean_account.do-account.email)[0],".","-")])]

  user_data = templatefile(
    "files/userdata_register",
    {
      docker_version = var.docker_version
      register_command = module.kubernetes_data.rke2_cluster_command
      node_roles = "--etcd"
    })

  provisioner "remote-exec" {
    connection {
      type          = "ssh"
      user          = var.user
      host          = self.ipv4_address
      private_key   = local.ssh_private_key
    }

    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
  }
}

resource "digitalocean_droplet" "rke2-cp" {
  count       = var.downstream_rke2_enabled ? var.rke2_cp_nodes : 0
  image       = var.nodes_image
  name        = "${var.prefix}-rke2-cp-${count.index}"
  vpc_uuid    = digitalocean_vpc.infra-clusters.id
  region      = var.region_server
  size        = var.size
  ssh_keys    = [local.ssh_public_fingerprint]
  tags        = [join("",["user:",replace(split("@",data.digitalocean_account.do-account.email)[0],".","-")])]

  user_data = templatefile(
    "files/userdata_register",
    {
      docker_version = var.docker_version
      register_command = module.kubernetes_data.rke2_cluster_command
      node_roles = "--controlplane"
    })

  provisioner "remote-exec" {
    connection {
      type          = "ssh"
      user          = var.user
      host          = self.ipv4_address
      private_key   = local.ssh_private_key
    }

    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
  }
}

resource "digitalocean_droplet" "rke2-worker" {
  count       = var.downstream_rke2_enabled ? var.rke2_worker_nodes : 0
  image       = var.nodes_image
  name        = "${var.prefix}-rke2-worker-${count.index}"
  vpc_uuid    = digitalocean_vpc.infra-clusters.id
  region      = var.region_server
  size        = var.size
  ssh_keys    = [local.ssh_public_fingerprint]
  tags        = [join("",["user:",replace(split("@",data.digitalocean_account.do-account.email)[0],".","-")])]

  user_data = templatefile(
    "files/userdata_register",
    {
      docker_version = var.docker_version
      register_command = module.kubernetes_data.rke2_cluster_command
      node_roles = "--worker"
    })

  provisioner "remote-exec" {
    connection {
      type          = "ssh"
      user          = var.user
      host          = self.ipv4_address
      private_key   = local.ssh_private_key
    }

    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
  }
}
