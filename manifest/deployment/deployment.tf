provider "kubernetes" {
  config_context_cluster = "my-cluster"
}

resource "kubernetes_secret" "aquasec-creds" {
  metadata {
    name = "aquasec-creds"
  }
  data = {
    username = base64encode("my-aquasec-username")
    password = base64encode("my-aquasec-password")
  }
}

resource "kubernetes_namespace" "aquasec" {
  metadata {
    name = "aquasec"
  }
}

resource "kubernetes_deployment" "aquasec" {
  metadata {
    name = "aquasec"
    namespace = kubernetes_namespace.aquasec.metadata[0].name
    labels = {
      app = "aquasec"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "aquasec"
      }
    }
    template {
      metadata {
        labels = {
          app = "aquasec"
        }
      }
      spec {
        container {
          name = "aquasec"
          image = "aquasec/aquasec-scanner:latest"
          env {
            name = "AQUASEC_USERNAME"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.aquasec-creds.metadata[0].name
                key = "username"
              }
            }
          }
          env {
            name = "AQUASEC_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.aquasec-creds.metadata[0].name
                key = "password"
              }
            }
          }
          volume_mount {
            name       = "var-lib-docker"
            mount_path = "/var/lib/docker"
          }
        }
        volume {
          name = "var-lib-docker"
          host_path {
            path = "/var/lib/docker"
          }
        }
      }
    }
  }
}
