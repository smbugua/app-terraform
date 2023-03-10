resource "google_container_cluster" "primary-private" {
  count       = var.gke_type == "public" ? 1 : 0
  provider    = google-beta
  location    = var.primary_region
  name        = var.prefix
  network     = var.network_name
  min_master_version = var.min_gke_master_version
  initial_node_count       = 3
  remove_default_node_pool = true

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.cluster_ipv4_cicdr_block
    }
  }

  resource_labels = {
    environment = var.env
  }
}

resource "google_container_node_pool" "primary-private-0" {
  count      = length(google_container_cluster.primary-private)
  provider   = google-beta
  location   = var.primary_region
  name       = var.node_pool_name
  cluster    = google_container_cluster.primary-private[0].name
  node_count = 3
  version    = var.min_gke_master_version

  timeouts {
    create = "60m"
    update = "60m"
  }

  node_config {
    machine_type = var.gke_machine_type

    shielded_instance_config {
      enable_secure_boot = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      environment = var.env
    }
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }

  upgrade_settings {
    max_surge = 1
    max_unavailable = 0
  }

  lifecycle {
    ignore_changes = [
      version
    ]
  }
}

resource "google_compute_router" "primary-nat-router" {
  count = var.gke_type == "public" ? 1 : 0
  name = "${var.prefix}-nat-router"
  region = google_compute_subnetwork.primary.region
  network = google_compute_network.primary.id
}

resource "google_compute_router_nat" "primary-nat" {
  count = length(google_compute_router.primary-nat-router)
  name = "${var.prefix}-nat"
  router = google_compute_router.primary-nat-router[0].name
  region = google_compute_router.primary-nat-router[0].region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
