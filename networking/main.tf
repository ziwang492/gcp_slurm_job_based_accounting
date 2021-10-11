variable "project" {
  type    = string
}

variable "zone" {
  type    = string
  default = "us-central-1a"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "network" {
  type    = string
  default = "default"
}

variable "sub_network" {
  type    = string
  default = "default"
}

variable "router_name" {
    default = "hpc-router" 
}

variable "router_bgp_asn" {
    default =  64514
}

variable "nat_router_name" {
    default = "hpc-router-nat" 
}

variable "subnetwork_ip_ranges_to_nat" {
    default = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "log_config_enable" {
    default =  true
}

variable "log_config_filter" {
    default = "ERRORS_ONLY" 
}


# Router - default
resource "google_compute_router" "router" {
  name    = var.router_name
  region  = var.region
  network = var.network


  bgp {
    asn = var.router_bgp_asn
  }
}

# static external IP addresses for NAT
resource "google_compute_address" "nat_default_ips" {
  depends_on = [
    google_compute_router.router,
  ]
  count  = 2
  name   = "nat-default-ip-${count.index}"
  region = var.region
}


# NAT - default
resource "google_compute_router_nat" "nat" {
  name                               = var.nat_router_name
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.nat_default_ips.*.self_link
  source_subnetwork_ip_ranges_to_nat = var.subnetwork_ip_ranges_to_nat

  log_config {
    enable = var.log_config_enable
    filter = var.log_config_filter
  }
}

output "nat_ips" {
  value = google_compute_address.nat_default_ips.*.address
}