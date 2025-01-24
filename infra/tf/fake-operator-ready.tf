# as the host driver and the nvidia container toolkit are provided within Talos as Shims,
# we need to create a daemonset that forces these to be marked as ready for the GPU operator
# TODO: "productionise" this
resource "kubernetes_daemonset" "fake_toolkit_ready" {
  metadata {
    name      = "fake-toolkit-ready"
    namespace = "gpu-operator"
  }

  depends_on = [
    kubernetes_namespace.gpu_operator_labels
  ]

  spec {
    selector {
      match_labels = {
        "k8s-app" = "fake-toolkit-ready"
      }
    }

    template {
      metadata {
        labels = {
          name    = "fake-toolkit-ready"
          "k8s-app" = "fake-toolkit-ready"
        }
      }

      spec {
        volume {
          name = "run-nvidia"

          host_path {
            path = "/run/nvidia/validations/"
          }
        }

        container {
          name  = "main"
          image = "alpine:3.19"

          command = ["sh", "-c"]
          args = [
            <<-EOF
              set -ex;
              touch /run/nvidia/validations/host-driver-ready;
              touch /run/nvidia/validations/toolkit-ready;
              touch /run/nvidia/validations/.driver-ctr-ready;
              touch /run/nvidia/validations/driver-ready
              sleep infinity
              EOF
          ]


          volume_mount {
            name          = "run-nvidia"
            mount_path    = "/run/nvidia/validations/"
            mount_propagation = "HostToContainer"
          }

          image_pull_policy = "IfNotPresent"
        }

        restart_policy = "Always"

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "node.kubernetes.io/instance-type"
                  operator = "In"
                  values = [
                    "g4g.40.kube.small",
                    "g4g.40.kube.medium",
                    "g4g.40.kube.large",
                    "g4g.40.kube.xlarge",
                    "g4g.kube.small",
                    "g4g.kube.medium",
                    "g4g.kube.large",
                    "g4g.kube.xlarge",
                    "an.g1.l40s.kube.x1",
                    "an.g1.l40s.kube.x2",
                    "an.g1.l40s.kube.x4",
                    "an.g1.l40s.kube.x8",
                    "an.g1.h100.kube.x1",
                    "an.g1.h100.kube.x2",
                    "an.g1.h100.kube.x4",
                    "an.g1.h100.kube.x8",
                    "an.g1.h200sxm.kube.x1",
                    "an.g1.h200sxm.kube.x8"
                  ]
                }
              }
            }
          }
        }

        toleration {
          key      = "nvidia.com/gpu"
          operator = "Exists"
          effect   = "NoSchedule"
        }

        priority_class_name = "system-node-critical"

      }
    }
  }
}
