virginia_cidr = "10.10.0.0/16"
subnets = ["10.10.0.0/24", "10.10.1.0/24"]

tags = {
  "env" = "dev"
  "owner" = "Julieta"
  "cloud" = "AWS"
  "IAC" = "Terraform"
  "IAC_version" = "1.14.4"
  "project" = "practica7"
  "region" = "virginia"
}

sg_ingress_cidr = "0.0.0.0/0"

ec2_specs = {
  ami = "ami-0532be01f26a3de55"
  instance_type = "t3.micro"
}

//enable_monitoring = true
enable_monitoring = 0

ingress_ports_list = [22, 80, 443]