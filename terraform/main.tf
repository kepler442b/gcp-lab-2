terraform {
  backend "gcs" {
    bucket  = "tf-state-kepler442b"
    prefix  = "terraform/state"
  }
}

provider "google" {
  version = "3.5.0"

  project = var.project
  region  = var.region
  zone    = var.zone

}

resource "google_container_cluster" "hello-world" {
  name               = var.cluster
  location           = var.zone
  initial_node_count = 2

  node_config {
    preemptible = true
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  
  }

}