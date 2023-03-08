variable "admin_username" { type = string }
variable "hostname" { type = string }
variable "key_name" { type = string }
variable "instance_type" { type = string }
variable "region" { type = string }
variable "resource_group" { type = string }

variable "ingress_addr_list" {
  type    = list(string)
  default = ["1.1.1.1/32"]
}