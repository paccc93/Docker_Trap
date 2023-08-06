locals {
 
 #ami      = "ami-0f34c5ae932e6f0e4" # Amazon Linux 
 ami      = "ami-053b0d53c279acc90" #Ubunutu 22.04
 type     = "t2.micro"
 name_tag = "My EC2 Instance"
 laptop_outbound_ip = "188.36.239.121"
}
variable "key_name" {
  type = string
}
variable "public_key" {
  type = string
}

# data "http" "laptop_outbound_ip" {
#   url = "http://ipv4.icanhazip.com"
# }

variable "security_groups" {
  description = "The attribute of security_groups information"
  type = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
