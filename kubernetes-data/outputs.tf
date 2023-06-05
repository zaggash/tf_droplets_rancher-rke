output "rancher_url" {
  description = "Rancher cluster DNS"
  value       = "https://${var.rancher_dnsname}"
}

output "rancher_kubeconfig_yaml" {
  description = "Rancher kubeconfig file"
  value       = rke_cluster.local-rancher.kube_config_yaml
}

output "rke-custom_cluster_command" {
  value       = var.downstream_rke_enabled ? rancher2_cluster.rke-custom.0.cluster_registration_token.0.node_command : ""
  description = "Docker command used to add a node to the rke-custom downstream cluster"
}

output "rke2_cluster_command" {
  value       = var.downstream_rke2_enabled ? rancher2_cluster_v2.rke2.0.cluster_registration_token.0.insecure_node_command : ""
  description = "Docker command used to add a node to the rke2 downstream cluster"
}
