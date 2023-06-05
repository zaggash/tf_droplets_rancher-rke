# Initialize Rancher server
resource "rancher2_bootstrap" "admin" {
  depends_on = [
    helm_release.rancher_server
  ]

  provider = rancher2.bootstrap

  password  = var.rancher_password
  telemetry = false
}

# Init Downstream cluster
resource "rancher2_cluster" "rke-custom" {
  count = var.downstream_rke_enabled ? 1 : 0
  provider = rancher2.admin

  name               = "rke-custom"
  rke_config {
    kubernetes_version = var.downstream_kubernetes_version
    enable_cri_dockerd    = length(regexall("v1.24.*", var.downstream_kubernetes_version)) > 0
  }
}

# Init downstream RKE2 cluster
resource "rancher2_cluster_v2" "rke2" {
  count = var.downstream_rke2_enabled ? 1 : 0
  provider = rancher2.admin

  name = "rke2"
  kubernetes_version = var.rke2_kubernetes_version
}
