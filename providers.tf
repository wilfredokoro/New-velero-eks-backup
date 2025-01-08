variable "kube_config_path" {
  default     = "~/.kube/config" # Default kubeconfig file path
  description = "Path to the kubeconfig file for the Kubernetes provider"
}
