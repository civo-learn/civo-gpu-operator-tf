resource "kubernetes_pod" "gpu_operator_test" {
  metadata {
    name = "gpu-operator-test"
  }

  spec {
    restart_policy     = "OnFailure"
    runtime_class_name = "nvidia"

    container {
      name  = "cuda-vector-add"
      image = "nvidia/samples:vectoradd-cuda11.6.0"

      resources {
        limits = {
          "nvidia.com/gpu" = 1
        }
      }
    }
  }
}
