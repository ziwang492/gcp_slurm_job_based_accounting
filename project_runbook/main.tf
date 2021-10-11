provider "google" {
  project     = "sample1-328718"
  region      = "us-central1"
}

variable "project" {
  type    = string
  default = "sample1-328718"
}

variable "zone" {
  type    = string
  default = "us-central-1a"
}

variable "region" {
  type    = string
  default = "us-central-1"
}

variable "sql_instance_name" {
  type    = string
  default = "slurm-accounting-instance"
}

variable "tier" {
  type    = string
  default = "db-f1-micro"
}

variable "network" {
  type    = string
  default = "default"
}

variable "sub_network" {
  type    = string
  default = "default"
}

variable "gcp_service_list" {
  type = list(string)
  default = [
    "file.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "billingbudgets.googleapis.com",
    "sourcerepo.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "bigquery.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com"
  ]
}

variable "slurm_version" {
    default = "b:slurm-19-05-8-1"
    # default = "b:slurm-20.11"
    type = string    
}

variable "machine_type" {
    default = "n1-standard-2"
    type = string    
}

variable compute_disk_size_gb {
    default = 20
}

variable compute_disk_type{
    default = "pd-standard"
}

variable max_node_count {
    default = 10
}

variable preemptible_bursting {
    type = bool
    default = true
}

module "service-enablement"  {
  source    = "../service-enablement"
  project   = var.project
  gcp_service_list= var.gcp_service_list
}

module "networking" {
  source          = "../networking"
  project         = var.project
  depends_on = [
    module.service-enablement
  ]
}

# module "filestore-server" {
#   source    = "../terraform/storage"
#   project   = var.project
#   zone      = var.zone
#   network   = var.network
#   depends_on = [
#     module.service-enablement,
#     # module.landingzone
#   ]
# }

# module "cloudsql" {
#   sql_instance_name = "${var.project}-${var.sql_instance_name}"
#   source            = "../cloudsql"
#   project_id        = var.project
#   region            = var.region
#   tier              = var.tier
#   network           = var.network
#   nat_ips           = ["184.94.46.66"]
#   deletion_protection = false
  

#   depends_on = [
#     module.service-enablement,
#     # module.networking
#   ]
    
# }

# module "slurm-cluster" {
#   source    = "../terraform/slurm-cluster"
#   project   = var.project
#   zone      = var.zone
#   cluster_name = "edafarm"

#   network_name            = var.network
#   subnetwork_name         = var.sub_network
#   slurm_version           = var.slurm_version
#   controller_scopes          = ["https://www.googleapis.com/auth/cloud-platform"]
#   login_node_scopes          = ["https://www.googleapis.com/auth/cloud-platform"]

#   cloudsql = {
#     server_ip = module.cloudsql.sql_ip
#     user      = "slurm"
#     password  = "verysecure"
#     db_name   = "slurm_accounting"
#   }

#   network_storage = [{
#       server_ip     = module.filestore-server.home-volume-ip-addresses
#       remote_mount  = "/home"
#       local_mount   = "/home"
#       fs_type       = "nfs"
#       mount_options = "defaults,hard,intr"
#     },{
#       server_ip     = module.filestore-server.tools-volume-ip-addresses
#       remote_mount  = "/tools"
#       local_mount   = "/tools"
#       fs_type       = "nfs"
#       mount_options = "defaults,hard,intr"
#   }]

#   partitions = [
#     { name                 = "debug"
#       machine_type         = var.machine_type
#       static_node_count    = 0
#       max_node_count       = var.max_node_count
#       zone                 = var.zone
#       compute_disk_type    = var.compute_disk_type
#       compute_disk_size_gb = var.compute_disk_size_gb
#       compute_labels       = {}
#       cpu_platform         = null
#       gpu_count            = 0
#       gpu_type             = null
#       network_storage      = []
#       preemptible_bursting = var.preemptible_bursting
#       vpc_subnet           = var.sub_network
#     },
#   ]

#   depends_on = [
#     module.cloudsql,
#     module.filestore-server
#   ]
# }
