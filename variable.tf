variable "region" {
    default = "ap-south-1"
}

variable "availability_zones" {
  default = "ap-south-1b"
}

variable "cidr_block_vpc" {
    default = "192.168.0.0/16"
}
variable "cidr_block_subnet" {
    default = "192.168.20.0/24"
}

variable "ami" {
    default = "ami-062df10d14676e201"  #ami (ubuntu)
}

variable "instance_type" {
    default = "t2.large"
}

variable "acc_key" {
    default = "Access_key" ##
  
}

variable "scrt_key" {
    default = "secret_key" ##
  
}

