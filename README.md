
# Velero Kubernetes Backup and Restore

This document provides instructions for setting up Velero for backing up and restoring Kubernetes resources on an Amazon EKS cluster using Terraform.

## Prerequisites
- AWS CLI
- Terraform 
- Helm

## Steps

### 1. Update Cluster to Current Version
```bash
aws eks update-kubeconfig --name <Cluster Name> --region us-east-1
```

### 2. Obtain the OIDC Provider from AWS Environment
Execute the following command to obtain the OIDC provider:
```bash
aws eks describe-cluster --name <cluster-name> --query "cluster.identity.oidc.issuer" --output text

```

### 3. Add the  Provider to your code
```bash
variable "oidc_provider_uri" {
  description = "The OIDC provider URL."
  type        = string
  default     = "oidc.eks.us-east-1.amazonaws.com/id/<providerID>"
}
```

### 4. Create Namespace for the Install
```bash
kubectl create ns velero
```

### 5. 
```bash
export KUBE_CONFIG_PATH=~/.kube/config
```
### 5. Run terraform
```bash
terraform init
terraform plan
terraform apply
```


### 6. Check if Velero Pods are Running
```bash
kubectl get pod -n velero
```

### 7. Test Velero Backup
```bash
velero backup create test-backup --include-namespaces velero
```

### 8. Verify Backup
```bash
velero backup get
```

---

Follow these steps to ensure Velero is properly installed and configured for your EKS cluster backup and restore operations.
