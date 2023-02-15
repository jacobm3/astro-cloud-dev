variable "instance_type" {
  type    = string
  default = "m5d.large"
}

variable "key_name" { type = string }

variable "region" { type = string }

variable "vpc_id" { type = string }

variable "hostname" { 
  type = string 
  default = "astro-dev"
  }

variable "ingress_addr_list" {
  type    = list(string)
  default = ["1.1.1.1/32"]
}

