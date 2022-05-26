variable "app_name" {}
variable "app_namespace" {}
variable "tfenv" {}
variable "cluster_oidc_issuer_url" {}
variable "aws_region" {}
variable "scale_down_util_threshold" {}
variable "skip_nodes_with_local_storage" {}
variable "skip_nodes_with_system_pods" {}
variable "cordon_node_before_term" {}
variable "tags" {}
variable "chart_version" {
  default = null
}