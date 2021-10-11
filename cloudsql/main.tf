resource "google_sql_database_instance" "instance" {
  name   = var.sql_instance_name
  region = var.region
  deletion_protection = var.deletion_protection

  settings {
    tier = var.tier
    ip_configuration {

      ipv4_enabled    = true
      
      dynamic "authorized_networks" {
        for_each = var.nat_ips
        iterator = ip

        content {
          name  = ip.value
          value = "${ip.value}"
        }
      }
    }
  }
}


resource "google_sql_database" "database" {
  name     = "slurm_accounting"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  name     = "slurm"
  instance = google_sql_database_instance.instance.name
  password = "verysecure"
}