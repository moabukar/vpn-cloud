variable "project_id" {
  description = "Project ID in GCP"
  default     = "mo-test-1"
}

variable "region" {
  description = "London's region"
  default = "europe-west2"
}

variable "ssh_pub_key_file" {
  default = "~/.ssh/id_rsa.pub"
}

variable "vm_name" {
  default = "uk-vpn"
}