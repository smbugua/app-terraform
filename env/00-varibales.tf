variable "GCP_JSON_KEY" {
  type = string
  default = ""
}
variable "gcp_project_id" {
  default = "<ENTER-GOOGLE-PROJECT-ID>"
}
variable "env" {
  type = string
  default = "<ENTER-ENV-NAME>"
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
variable "psql_db" {
  default= "<configurre db name>"
}

variable "psql_user" {
  default= "<configurre db username>"
}

variable "postgres_instance_name" {
  default= "<configurre db instance name>"
}
