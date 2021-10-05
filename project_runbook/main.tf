variable "project" {
  type    = string
  default = "positive-rush-328123"
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


module "service-enablement"  {
  source    = "../service-enablement"
  project   = var.project
  gcp_service_list= var.gcp_service_list
}
