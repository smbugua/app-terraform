variable "GCP_JSON_KEY" {
  type = string
  default = ""
}
variable "gcp_project_id" {
  default = "galleria-370207"
}
variable "env" {
  type = string
  default = "terraform-test"
}

variable "primary_region" {
  type = string
  default = "us-central1"
}
variable "gke_machine_type" {
  type = string
  default = "e2-standard-4"
}
variable "min_gke_master_version" {
  type = string
  default = "1.24.8-gke.2000"
}
variable "prefix" {
  type = string
  default = "app"
}
variable "gke_type" {
  type = string
  default = "public"
}
