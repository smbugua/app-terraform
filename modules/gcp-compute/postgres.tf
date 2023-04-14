resource "google_sql_database_instance" "primary-postgres" {
  # count = var.gke_type == "none" ? 0 : 1
  count = 1
  name = var.postgres_instance_name

  database_version = "POSTGRES_14"
  deletion_protection = false
  region = var.primary_region

  settings {
    tier = "db-custom-1-3840" # 1CPU / 3840 MiBs https://cloud.google.com/sql/docs/postgres/create-instance
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled = "false"

      private_network = google_compute_network.primary.self_link
    }

    backup_configuration {
      enabled = "true"
      start_time = "21:00"
      point_in_time_recovery_enabled = true
    }

    database_flags {
      name = "max_connections"
      value = 10000
    }

    database_flags {
      name = "cloudsql.logical_decoding"
      value = "on"
    }

    database_flags {
      name = "log_checkpoints"
      value = "on"
    }

    database_flags {
      name = "log_connections"
      value = "on"
    }

    database_flags {
      name = "log_disconnections"
      value = "on"
    }
    database_flags {
      name = "log_lock_waits"
      value = "on"
    }
    database_flags {
      name = "log_min_duration_statement"
      value = 1
    }

    database_flags {
      name = "log_temp_files"
      value = 0
    }

    user_labels = {
      environment = var.env
    }

    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = false
      record_client_address   = false
    }
  }
}

resource "google_sql_user" "primary-postgres-user" {
  count = length(google_sql_database_instance.primary-postgres)
  name = var.psql_user
  instance = google_sql_database_instance.primary-postgres[0].name
  password = var.db_password
}

resource "google_sql_database" "primary-postgres-db" {
  count = length(google_sql_database_instance.primary-postgres)
  name = var.psql_db
  instance = google_sql_database_instance.primary-postgres[0].name
}
