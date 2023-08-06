//network.tf
resource "aws_vpc" "test-env" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "test-env"
  }
}
resource "aws_eip" "ip-test-env" {
  instance = "${aws_instance.my_vm.id}"
  vpc      = true
}

//subnets.tf
resource "aws_subnet" "subnet-uno" {
  cidr_block = "${cidrsubnet(aws_vpc.test-env.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.test-env.id}"
  availability_zone = "us-east-1a"
}

resource "aws_route_table" "route-table-test-env" {
  vpc_id = "${aws_vpc.test-env.id}"
route {
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.test-env-gw.id}"
  }
  tags = {
    Name = "test-env-route-table"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-uno.id}"
  route_table_id = "${aws_route_table.route-table-test-env.id}"
}
//security.tf
resource "aws_security_group" "ingress-all-test" {
name = "allow-all-sg"
vpc_id = "${aws_vpc.test-env.id}"
ingress {
  description = "Laptop Public IP"
  from_port   = 2222   
  to_port     = 2222
  protocol    = "tcp"
  #cidr_blocks = ["${chomp(data.http.laptop_outbound_ip.response_body)}/32"]
  cidr_blocks = ["${local.laptop_outbound_ip}/32"]
  #cidr_blocks      = ["0.0.0.0/0"]
  }
ingress {
  description = "SSH From Everywhere"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  }
dynamic "ingress" {
  for_each = var.security_groups
  content {
    description = ingress.value["name"]
    from_port   = ingress.value["from_port"]
    to_port     = ingress.value["to_port"]
    protocol    = ingress.value["protocol"]
    cidr_blocks = ingress.value["cidr_blocks"]
  }
}
egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
}
//gateways.tf
resource "aws_internet_gateway" "test-env-gw" {
  vpc_id = "${aws_vpc.test-env.id}"
  tags = {
    Name = "test-env-gw"
  }
}