module "kubernetes_data" {
  source = "./kubernetes-data"

  do_account-email              = data.digitalocean_account.do-account.email
  user                          = var.user
  privkey_openssh               = local.ssh_private_key

  rancher-all                   = digitalocean_droplet.rancher-all[*]
  rancher-etcd                  = digitalocean_droplet.rancher-etcd
  rancher-cp                    = digitalocean_droplet.rancher-cp
  rancher-worker                = digitalocean_droplet.rancher-worker

  rancher_kubernetes_version    = var.rancher_kubernetes_version
  use_cluster_yaml              = var.use_cluster_yaml

  cert_manager_version          = var.cert_manager_version
  rancher_version               = var.rancher_version
  rancher_dnsname               = "${local.rancherlb-dns}"

  rancher_password              = var.rancher_password
  downstream_rke_enabled        = var.downstream_rke_enabled
  downstream_kubernetes_version = var.downstream_kubernetes_version
  downstream_rke2_enabled       = var.downstream_rke2_enabled
  rke2_kubernetes_version       = var.rke2_kubernetes_version
}

resource "local_file" "rancher_kubeconfig_yaml" {
  filename        = "./kubeconfig_rke_local-rancher.yml"
  content         = module.kubernetes_data.rancher_kubeconfig_yaml
  file_permission = "0644"

  provisioner "local-exec" {
    command = "rm -f ./kubeconfig_rke_local-rancher.yml"
    when    = destroy
  }
}

resource "local_file" "rke_cluster_yaml" {
  filename        = "./rke-cluster.yaml"
  content         = module.kubernetes_data.rke_cluster_yaml
  file_permission = "0644"

  provisioner "local-exec" {
    command = "rm -f ./rke-cluster.yaml"
    when    = destroy
  }
}

resource "local_file" "rke_cluster_state" {
  filename        = "./rke-cluster.rkestate"
  content         = module.kubernetes_data.rke_cluster_state
  file_permission = "0644"

  provisioner "local-exec" {
    command = "rm -f ./rke-cluster.rkestate"
    when    = destroy
  }
}
