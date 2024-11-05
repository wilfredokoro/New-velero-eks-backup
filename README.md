# New-velero-eks-backup


# Velero Kubernetes Backup and Restore

This document provides instructions for setting up Velero for backing up and restoring Kubernetes resources on an Amazon EKS cluster.

## Prerequisites
- AWS CLI
- eksctl
- Helm

## Steps

### 1. Update Cluster to Current Version
```bash
aws eks update-kubeconfig --name soar-eks-testing --region us-east-1
```

### 2. Create IAM Policy
Execute the following command to create the IAM Policy:
```bash
aws iam create-policy \
    --policy-name SwimlaneVeleroAccessPolicy \
    --policy-document file://velero_policy.json
```

### 3. Associate IAM OIDC Provider with EKS Cluster
```bash
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster soar-eks-testing \
    --approve
```

### 4. Verify OIDC Provider
Ensure the OIDC provider is associated:
```bash
aws iam list-open-id-connect-providers | grep soar-eks-testing
```

### 5. Create an IAM Service Account for Velero
```bash
eksctl create iamserviceaccount \
    --cluster my-eks-cluster \
    --name velero-server \
    --namespace velero \
    --role-name Swimlane-eks-velero-backup \
    --role-only \
    --attach-policy-arn arn:aws:iam::195911796256:policy/SwimlaneVeleroAccessPolicy \
    --approve
```

### 6. Add VMware Tanzu Repository to Helm Repos
```bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts
```

### 7. Update the Local Helm Repository
```bash
helm repo update
```

### 8. Create Namespace for the Install
```bash
kubectl create ns velero
```

### 9. Install Velero with Custom Values
Add or update the necessary values in `values.yaml`, then run:
```bash
helm install vmware-tanzu/velero --namespace velero -f values.yaml
```

### 10. Verify Installation
```bash
helm list -n velero
```

### 11. Check if Velero Pods are Running
```bash
kubectl get pod -n velero
```

### 12. Test Velero Backup
```bash
velero backup create test-backup --include-namespaces velero
```

### 13. Verify Backup
```bash
velero backup get
```

---

Follow these steps to ensure Velero is properly installed and configured for your EKS cluster backup and restore operations.
