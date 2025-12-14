terraform {
  # If you're still on old Terraform, you can change this back to >= 0.12
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  backend "gcs" {
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host = "https://${google_container_cluster.default.endpoint}"

  token = data.google_client_config.current.access_token

  client_certificate = base64decode(
    google_container_cluster.default.master_auth[0].client_certificate
  )
  client_key = base64decode(
    google_container_cluster.default.master_auth[0].client_key
  )
  cluster_ca_certificate = base64decode(
    google_container_cluster.default.master_auth[0].cluster_ca_certificate
  )
}
