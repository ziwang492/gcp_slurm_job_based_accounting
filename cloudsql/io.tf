variable "project_id" {
  type = string 
}

variable "region" {
  type = string 
}

variable "tier" {
  type = string
}

variable "network" {
  type = string
}

variable "sql_instance_name" {
  type = string
}

variable "nat_ips" {
  type = list
}

variable "deletion_protection" {
  type = string
  default = false
}

output "sql_ip" {
  value = google_sql_database_instance.instance.ip_address.0.ip_address
}