terraform {
  backend "remote"{
    hostname = "app.terraform.io"
    organization = "nebula_io"
    workspaces {
      name = "app-test"
    }
  }
    required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
        google-beta = {
        source = "hashicorp/google-beta" #some modules require google-beta
        version = "4.35.0"
    }
  }

}
#Google provider
provider "google" {
    credentials = var.GCP_JSON_KEY
    project = var.gcp_project_id
    region = var.primary_region
}
provider "google-beta" {
    credentials = var.GCP_JSON_KEY
    project = var.gcp_project_id
    region = var.primary_region  
}
#to provision our gcp resources 
#  module "gcp" {
#    env = var.env
#    source = "../modules/gcp-compute"
#    prefix = var.prefix
#    gcp_project_id = var.gcp_project_id
#    gke_machine_type = var.gke_machine_type
#    primary_region = var.primary_region
#    min_gke_master_version = var.min_gke_master_version
#    gke_type = var.gke_type
#  }
