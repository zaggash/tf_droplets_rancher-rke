resource "rke_cluster" "local-rancher" {
  
  dynamic "nodes" {
    for_each    = var.rancher-all
    content {
      address   = nodes.value.ipv4_address
      user      = var.user
      role      = ["controlplane", "worker", "etcd"]
      ssh_key   = var.privkey_openssh
    }
  }
  dynamic "nodes" {
    for_each    = var.rancher-etcd
    content {
      address   = nodes.value.ipv4_address
      user      = var.user
      role      = ["etcd"]
      ssh_key   = var.privkey_openssh
    }
  }
  dynamic "nodes" {
    for_each    = var.rancher-cp
    content {
      address   = nodes.value.ipv4_address
      user      = var.user
      role      = ["controlplane"]
      ssh_key   = var.privkey_openssh
    }
  }
  dynamic "nodes" {
    for_each    = var.rancher-worker
    content {
      address   = nodes.value.ipv4_address
      user      = var.user
      role      = ["worker"]
      ssh_key   = var.privkey_openssh
    }
  }

  cluster_name          = "local-rancher"
  ignore_docker_version = true
  kubernetes_version    = var.rancher_kubernetes_version
  enable_cri_dockerd    = length(regexall("v1.24.*", var.rancher_kubernetes_version)) > 0
  

  cluster_yaml          = var.use_cluster_yaml == true ? file("./rancher-cluster.yaml") : ""
}
