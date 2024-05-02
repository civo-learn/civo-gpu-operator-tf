
# Create labels for the GPU operator namespace
resource "kubernetes_namespace" "gpu_operator_labels" {
  metadata {
    name = "gpu-operator"
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

# Helm release configuration for the Nvidia GPU operator
resource "helm_release" "gpu_operator" {
  name       = "gpu-operator"
  repository = "https://helm.ngc.nvidia.com/nvidia"
  chart      = "gpu-operator"
  namespace  = "gpu-operator" # Directly use the string here
  version    = "v23.9.2"

  # load the values for the nvidia gpu operator
  values = [
    "${file("values/gpu-operator-values.yaml")}"
  ]

  # don't create the operator until the namespace is labeled
  depends_on = [
    kubernetes_namespace.gpu_operator_labels
  ]
}

# Output the status of the GPU operator helm release
output "helm_release_status" {
  value = helm_release.gpu_operator.status
}



