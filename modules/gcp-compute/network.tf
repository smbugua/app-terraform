resource "google_compute_network" "primary" {
  provider = google-beta
  name = "${var.prefix}-primary"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary" {
  provider         = google-beta
  name             = "${var.prefix}-primary"
  ip_cidr_range    = "10.100.0.0/20"
  region           = var.primary_region
  network          = google_compute_network.primary.self_link

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_global_address" "google-managed-services" {
  name          = "${var.prefix}-google-managed-services"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = google_compute_network.primary.self_link
}

resource "google_service_networking_connection" "servicenetworking" {
  network                 = google_compute_network.primary.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.google-managed-services.name]
}
