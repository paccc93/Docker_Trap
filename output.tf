output "public_ip" {
 value       = aws_instance.my_vm.public_ip
 description = "Public IP Address of EC2 instance"
}

output "instance_id" {
 value       = aws_instance.my_vm.id
 description = "Instance ID"
}
output "pub_ip" {
 value       = aws_eip.ip-test-env.public_ip
 description = "Public Ip"
}
