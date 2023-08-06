provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_vm" {
  ami           = local.ami
  instance_type = local.type
  key_name = "Login"
  security_groups = ["${aws_security_group.ingress-all-test.id}"]
  subnet_id = "${aws_subnet.subnet-uno.id}"

  tags = {
    Name = local.name_tag
  }
  user_data = "${file("install.sh")}"
  depends_on = [

  aws_key_pair.devkey

]
}
resource "aws_key_pair" "devkey" {
  key_name   = var.key_name
  public_key = var.public_key
}
