


# Helm release configuration for the Nvidia GPU operator
resource "helm_release" "monitoring_stack" {
  name       = "monitoring-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring" # Directly use the string here
  create_namespace = true
  wait = false

  # load the values for the nvidia gpu operator
  values = [
    "${file("values/monitoring-stack-values.yaml")}"
  ]

  # don't create the operator until the namespace is labeled
  depends_on = [
    kubernetes_namespace.gpu_operator_labels
  ]
}






