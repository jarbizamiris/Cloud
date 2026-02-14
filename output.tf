// PARA TRABAJAR CON FOR_EACH Y SETS
output "ec2_public_ips" {
  value = {
    for name, instance in aws_instance.public_instance :
    name => instance.public_ip
  }
}